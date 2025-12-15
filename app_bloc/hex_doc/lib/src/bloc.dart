import 'dart:io';

import 'package:archive/archive.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

part 'event.dart';
part 'state.dart';

class HexDocBloc extends Bloc<HexDocEvent, HexDocState> {
  HexDocBloc(this.appSupportDir, this.tmpDir) : super(const HexDocState()) {
    on<HexDocEventInit>(_onHexDocEventInit);
    on<HexDocEventSetup>(_onHexDocEventSetup);
    on<HexDocEventList>(_onHexDocEventList);
    on<HexDocEventDelete>(_onHexDocEventDelete);
    on<HexDocEventDeleteAll>(_onHexDocEventDeleteAll);
    on<HexDocEventToggleExpanded>(_onHexDocEventToggleExpanded);
  }

  String getUrl(String name, String version) {
    return 'https://repo.hex.pm/docs/$name-$version.tar.gz';
  }

  final Directory appSupportDir;
  final Directory tmpDir;

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
        versions.removeWhere((doc) => doc.packageVersion == event.packageVersion);
        if (versions.isEmpty) {
          newDocs.remove(event.packageName);
        }
      }
      emitter(state.copyWith(docs: newDocs));

      if (await packageDir.exists()) {
        final remainingFiles = await packageDir.list().toList();
        if (remainingFiles.isEmpty) {
          await packageDir.delete();
        }
      }
    } catch (e) {
      emitter(state.copyWith(stats: DocStats.error, error: e));
    }
  }

  Future<void> _onHexDocEventDeleteAll(
    HexDocEventDeleteAll event,
    Emitter<HexDocState> emitter,
  ) async {
    try {
      final docsDir = Directory(p.join(appSupportDir.path, 'hex_docs'));
      if (await docsDir.exists()) {
        await docsDir.delete(recursive: true);
      }
      emitter(state.copyWith(docs: {}, expandedState: {}));
    } catch (e) {
      emitter(state.copyWith(stats: DocStats.error, error: e));
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
    try {
      final dir = p.join(
        appSupportDir.path,
        'hex_docs',
        event.packageName,
        event.packageVersion,
      );
      final indexFile = File(p.join(dir, 'index.html'));
      debugPrint('HexDocBloc: Checking for index file at: ${indexFile.path}');
      debugPrint('HexDocBloc: File exists: ${await indexFile.exists()}');
      
      if (await indexFile.exists()) {
        debugPrint('HexDocBloc: Found existing index file, using: ${indexFile.path}');
        emitter(state.copyWith(
          stats: DocStats.ok,
          indexFile: indexFile.path,
        ));
      } else {
        emitter(state.copyWith(stats: DocStats.downloading));
        final response = await http.get(Uri.parse(getUrl(
          event.packageName,
          event.packageVersion,
        )));

        if (response.statusCode == 200) {
          emitter(state.copyWith(stats: DocStats.extracting));
          final gzipDecoder = GZipDecoder();
          final tarBytes = gzipDecoder.decodeBytes(response.bodyBytes);

           final tarArchive = TarDecoder().decodeBytes(tarBytes);
           debugPrint('HexDocBloc: Extracted ${tarArchive.files.length} files from archive');

           for (final file in tarArchive.files) {
             final filename = file.name;
             final filePath = p.join(dir, filename);
             debugPrint('HexDocBloc: Extracting file: $filename -> $filePath');

             if (file.isFile) {
               final outFile = File(filePath);
               await outFile.create(recursive: true);
               await outFile.writeAsBytes(file.content as List<int>);
             } else {
               final dir = Directory(filePath);
               await dir.create(recursive: true);
             }
           }

           debugPrint('HexDocBloc: Extraction complete, index file: ${indexFile.path}');
           emitter(state.copyWith(
             stats: DocStats.ok,
             indexFile: indexFile.path,
           ));
        } else {
          emitter(state.copyWith(stats: DocStats.error));
        }
      }
    } catch (e) {
      emitter(state.copyWith(stats: DocStats.error, error: e));
    }
  }
}
