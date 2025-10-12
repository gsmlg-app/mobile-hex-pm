import 'package:app_database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Database Tests', () {
    late AppDatabase database;

    setUp(() async {
      // Create an in-memory database for testing
      database = AppDatabase();
    });

    tearDown(() async {
      await database.close();
    });

    test('Database should create docs_server_config table', () async {
      // Try to select from the docs_server_config table
      final configs = await database.select(database.docsServerConfig).get();

      // Should be empty initially
      expect(configs, isEmpty);
    });

    test('Database should insert and retrieve server config', () async {
      // Insert a test config
      await database.into(database.docsServerConfig).insert(
        DocsServerConfigCompanion.insert(
          host: Value('test-host'),
          port: Value(9999),
          autoStart: Value(true),
          enabled: Value(false),
        ),
      );

      // Retrieve the config
      final configs = await database.select(database.docsServerConfig).get();

      // Should have one config
      expect(configs.length, 1);

      final config = configs.first;
      expect(config.host, 'test-host');
      expect(config.port, 9999);
      expect(config.autoStart, true);
      expect(config.enabled, false);
    });

    test('Database should update existing server config', () async {
      // Insert initial config
      await database.into(database.docsServerConfig).insert(
        DocsServerConfigCompanion.insert(
          host: Value('initial-host'),
          port: Value(8080),
          autoStart: Value(false),
          enabled: Value(true),
        ),
      );

      // Update the config
      await (database.update(database.docsServerConfig)..where((tbl) => tbl.id.equals(1)))
          .write(DocsServerConfigCompanion(
        host: Value('updated-host'),
        port: Value(9090),
        autoStart: Value(true),
        enabled: Value(false),
        updatedAt: Value(DateTime.now()),
      ));

      // Retrieve the updated config
      final configs = await database.select(database.docsServerConfig).get();

      expect(configs.length, 1);

      final config = configs.first;
      expect(config.host, 'updated-host');
      expect(config.port, 9090);
      expect(config.autoStart, true);
      expect(config.enabled, false);
    });
  });
}