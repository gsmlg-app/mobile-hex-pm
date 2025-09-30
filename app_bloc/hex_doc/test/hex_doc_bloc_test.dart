import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:hex_doc_bloc/hex_doc_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('HexDocBloc', () {
    late HexDocBloc hexDocBloc;
    late MockHttpClient mockHttpClient;
    late Directory appSupportDir;
    late Directory tmpDir;
    const packageName = 'my_package';
    const packageVersion = '1.0.0';
    const docId = '$packageName-$packageVersion';

    setUp(() {
      mockHttpClient = MockHttpClient();
      appSupportDir = Directory.systemTemp.createTempSync();
      tmpDir = Directory.systemTemp.createTempSync();
      hexDocBloc = HexDocBloc(
        appSupportDir,
        tmpDir,
        client: mockHttpClient,
      );
    });

    tearDown(() {
      appSupportDir.deleteSync(recursive: true);
      tmpDir.deleteSync(recursive: true);
      hexDocBloc.close();
    });

    test('initial state is correct', () {
      expect(hexDocBloc.state, const HexDocState());
    });

    group('HexDocEventSetup', () {
      final tarBytes = _createTestTarGz();

      blocTest<HexDocBloc, HexDocState>(
        'emits [downloading, extracting, ok] when download is successful',
        build: () {
          when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async => http.Response.bytes(tarBytes, 200),
          );
          return hexDocBloc;
        },
        act: (bloc) => bloc.add(const HexDocEventSetup(
          packageName: packageName,
          packageVersion: packageVersion,
        )),
        expect: () => [
          const HexDocState(status: {docId: DocStats.downloading}),
          const HexDocState(status: {docId: DocStats.extracting}),
          HexDocState(
            status: const {docId: DocStats.ok},
            indexFiles: {
              docId: p.join(appSupportDir.path, 'hex_docs', packageName,
                  packageVersion, 'index.html')
            },
          ),
        ],
        verify: (_) {
          final indexFile = File(p.join(appSupportDir.path, 'hex_docs',
              packageName, packageVersion, 'index.html'));
          expect(indexFile.existsSync(), isTrue);
        },
      );

      blocTest<HexDocBloc, HexDocState>(
        'emits [downloading, error] when download fails',
        build: () {
          when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async => http.Response('Not Found', 404),
          );
          return hexDocBloc;
        },
        act: (bloc) => bloc.add(const HexDocEventSetup(
          packageName: packageName,
          packageVersion: packageVersion,
        )),
        expect: () => [
          const HexDocState(status: {docId: DocStats.downloading}),
          isA<HexDocState>().having(
            (s) => s.status[docId],
            'status',
            DocStats.error,
          ),
        ],
      );

      blocTest<HexDocBloc, HexDocState>(
        'emits [ok] when documentation already exists',
        build: () {
          final indexFile = File(p.join(appSupportDir.path, 'hex_docs',
              packageName, packageVersion, 'index.html'));
          indexFile.createSync(recursive: true);
          return hexDocBloc;
        },
        act: (bloc) => bloc.add(const HexDocEventSetup(
          packageName: packageName,
          packageVersion: packageVersion,
        )),
        expect: () => [
          HexDocState(
            status: const {docId: DocStats.ok},
            indexFiles: {
              docId: p.join(appSupportDir.path, 'hex_docs', packageName,
                  packageVersion, 'index.html')
            },
          ),
        ],
      );
    });

    group('HexDocEventDelete', () {
      blocTest<HexDocBloc, HexDocState>(
        'emits new state when documentation is deleted',
        build: () {
          final indexFile = File(p.join(appSupportDir.path, 'hex_docs',
              packageName, packageVersion, 'index.html'));
          indexFile.createSync(recursive: true);
          return hexDocBloc;
        },
        seed: () => HexDocState(
          docs: {
            packageName: const [
              DocInfo(
                  packageName: packageName, packageVersion: packageVersion)
            ]
          },
          status: const {docId: DocStats.ok},
          indexFiles: {
            docId: p.join(appSupportDir.path, 'hex_docs', packageName,
                packageVersion, 'index.html')
          },
        ),
        act: (bloc) => bloc.add(const HexDocEventDelete(
          packageName: packageName,
          packageVersion: packageVersion,
        )),
        expect: () => [
          const HexDocState(
            docs: {},
            status: {},
            indexFiles: {},
          ),
        ],
        verify: (_) {
          final docDir = Directory(p.join(
              appSupportDir.path, 'hex_docs', packageName, packageVersion));
          expect(docDir.existsSync(), isFalse);
        },
      );
    });
  });
}

Uint8List _createTestTarGz() {
  final archive = Archive()
    ..addFile(ArchiveFile('index.html', 12, Uint8List.fromList('hello world'.codeUnits)));
  final tarData = TarEncoder().encode(archive);
  final gzipped = GZipEncoder().encode(tarData);
  if (gzipped == null) {
    // This should not happen with the test data, but it's good practice to handle.
    throw Exception('Gzip encoding failed');
  }
  return Uint8List.fromList(gzipped);
}