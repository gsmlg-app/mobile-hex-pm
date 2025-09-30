import 'dart:io';

import 'package:archive/archive.dart';
import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

part 'event.dart';
part 'state.dart';

class HexDocBloc extends Bloc<HexDocEvent, HexDocState> {
  HexDocBloc(
    this.appSupportDir,
    this.tmpDir, {
    http.Client? client,
  })  : _client = client ?? http.Client(),
        super(const HexDocState()) {
    on<HexDocEventInit>(_onHexDocEventInit);
    on<HexDocEventSetup>(_onHexDocEventSetup);
    on<HexDocEventList>(_onHexDocEventList);
    on<HexDocEventDelete>(_onHexDocEventDelete);
    on<HexDocEventToggleExpanded>(_onHexDocEventToggleExpanded);
  }

  String getUrl(String name, String version) {
    return 'https://repo.hex.pm/docs/$name-$version.tar.gz';
  }

  final Directory appSupportDir;
  final Directory tmpDir;
  final http.Client _client;
  final Mutex _mutex = Mutex();

  Future<void> _onHexDocEventInit(
    HexDocEventInit event,
    Emitter<HexDocState> emitter,
  ) async {
    emitter(state.copyWith());
  }

  Future<void> _onHexDocEventToggleExpanded(
    HexDocEventToggleExpanded event,
    Emitter<HexDocState> emitter,
  ) async {
    final newExpandedState = Map<String, bool>.from(state.expandedState);
    newExpandedState[event.packageName] =
        !(newExpandedState[event.packageName] ?? false);
    emitter(state.copyWith(expandedState: newExpandedState));
  }

  Future<void> _onHexDocEventDelete(
    HexDocEventDelete event,
    Emitter<HexDocState> emitter,
  ) async {
    final docId = '${event.packageName}-${event.packageVersion}';
    try {
      final packageDir = Directory(p.join(
        appSupportDir.path,
        'hex_docs',
        event.packageName,
      ));
      final versionDir = Directory(p.join(
        packageDir.path,
        event.packageVersion,
      ));

      if (await versionDir.exists()) {
        await versionDir.delete(recursive: true);
      }

      final newDocs = Map<String, List<DocInfo>>.from(state.docs);
      final versions = newDocs[event.packageName];
      if (versions != null) {
        versions
            .removeWhere((doc) => doc.packageVersion == event.packageVersion);
        if (versions.isEmpty) {
          newDocs.remove(event.packageName);
        }
      }

      final newStatus = Map<String, DocStats>.from(state.status);
      newStatus.remove(docId);

      final newIndexFiles = Map<String, String>.from(state.indexFiles);
      newIndexFiles.remove(docId);

      emitter(state.copyWith(
        docs: newDocs,
        status: newStatus,
        indexFiles: newIndexFiles,
      ));

      if (await packageDir.exists()) {
        final remainingFiles = await packageDir.list().toList();
        if (remainingFiles.isEmpty) {
          await packageDir.delete();
        }
      }
    } catch (e) {
      final newStatus = Map<String, DocStats>.from(state.status);
      newStatus[docId] = DocStats.error;
      emitter(state.copyWith(status: newStatus, error: e));
    }
  }

  Future<void> _onHexDocEventList(
    HexDocEventList event,
    Emitter<HexDocState> emitter,
  ) async {
    final docsDir = Directory(p.join(appSupportDir.path, 'hex_docs'));
    if (await docsDir.exists()) {
      final packages = await docsDir.list().toList();
      final docs = <String, List<DocInfo>>{};
      for (final package in packages) {
        if (package is Directory) {
          final packageName = p.basename(package.path);
          final versions = await Directory(package.path).list().toList();
          final docInfos = <DocInfo>[];
          for (final version in versions) {
            if (version is Directory) {
              docInfos.add(DocInfo(
                packageName: packageName,
                packageVersion: p.basename(version.path),
              ));
            }
          }
          if (docInfos.isNotEmpty) {
            docs[packageName] = docInfos;
          }
        }
      }
      emitter(state.copyWith(docs: docs));
    }
  }

  Future<void> _onHexDocEventSetup(
    HexDocEventSetup event,
    Emitter<HexDocState> emitter,
  ) async {
    final docId = '${event.packageName}-${event.packageVersion}';
    try {
      final dir = p.join(
        appSupportDir.path,
        'hex_docs',
        event.packageName,
        event.packageVersion,
      );
      final indexFile = File(p.join(dir, 'index.html'));

      if (await indexFile.exists()) {
        final newStatus = Map<String, DocStats>.from(state.status);
        newStatus[docId] = DocStats.ok;
        final newIndexFiles = Map<String, String>.from(state.indexFiles);
        newIndexFiles[docId] = indexFile.path;

        emitter(state.copyWith(
          status: newStatus,
          indexFiles: newIndexFiles,
        ));
        return;
      }

      await _mutex.protect(() async {
        // Re-check after acquiring lock in case another process downloaded the file.
        if (await indexFile.exists()) {
          final newStatus = Map<String, DocStats>.from(state.status);
          newStatus[docId] = DocStats.ok;
          final newIndexFiles = Map<String, String>.from(state.indexFiles);
          newIndexFiles[docId] = indexFile.path;
          emitter(state.copyWith(
            status: newStatus,
            indexFiles: newIndexFiles,
          ));
          return;
        }

        final newStatus = Map<String, DocStats>.from(state.status);
        newStatus[docId] = DocStats.downloading;
        emitter(state.copyWith(status: newStatus));

        final response = await _client.get(Uri.parse(getUrl(
          event.packageName,
          event.packageVersion,
        )));

        if (response.statusCode == 200) {
          final newStatus = Map<String, DocStats>.from(state.status);
          newStatus[docId] = DocStats.extracting;
          emitter(state.copyWith(status: newStatus));

          final gzipDecoder = GZipDecoder();
          final tarBytes = gzipDecoder.decodeBytes(response.bodyBytes);
          final tarArchive = TarDecoder().decodeBytes(tarBytes);

          for (final file in tarArchive.files) {
            final filename = file.name;
            final filePath = p.join(dir, filename);

            if (file.isFile) {
              final outFile = File(filePath);
              await outFile.create(recursive: true);
              await outFile.writeAsBytes(file.content as List<int>);
            } else {
              final dir = Directory(filePath);
              await dir.create(recursive: true);
            }
          }

          final newStatusOk = Map<String, DocStats>.from(state.status);
          newStatusOk[docId] = DocStats.ok;
          final newIndexFiles = Map<String, String>.from(state.indexFiles);
          newIndexFiles[docId] = indexFile.path;

          emitter(state.copyWith(
            status: newStatusOk,
            indexFiles: newIndexFiles,
          ));
        } else {
          throw Exception(
              'Failed to download documentation: ${response.statusCode}');
        }
      });
    } catch (e) {
      final newStatus = Map<String, DocStats>.from(state.status);
      newStatus[docId] = DocStats.error;
      emitter(state.copyWith(status: newStatus, error: e));
    }
  }
}