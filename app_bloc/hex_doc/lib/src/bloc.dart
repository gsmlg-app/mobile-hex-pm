import 'dart:io';

import 'package:archive/archive.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

part 'event.dart';
part 'state.dart';

class HexDocBloc extends Bloc<HexDocEvent, HexDocState> {
  HexDocBloc(this.appSupportDir, this.tmpDir) : super(HexDocState.initial()) {
    on<HexDocEventInit>(_onHexDocEventInit);
    on<HexDocEventSetup>(_onHexDocEventSetup);
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
      if (await indexFile.exists()) {
        emitter(state.copyWith(stats: DocStats.ok));
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
