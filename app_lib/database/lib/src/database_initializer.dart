import 'package:logging/logging.dart';

import 'database.dart';

class DatabaseInitializer {
  static final Logger _logger = Logger('DatabaseInitializer');

  static Future<void> ensureServerConfigTableExists(
      AppDatabase database) async {
    try {
      // Try to query the docs_server_config table
      await database.select(database.docsServerConfig).get();
      _logger.info('docs_server_config table exists');
    } catch (e) {
      _logger
          .warning('docs_server_config table does not exist, creating it: $e');

      try {
        // Create the table manually using raw SQL
        final result = await database
            .customSelect(
                'SELECT name FROM sqlite_master WHERE type=\'table\' AND name=\'docs_server_config\'')
            .get();

        if (result.isEmpty) {
          // Table doesn't exist, create it
          await database.customStatement('''
            CREATE TABLE IF NOT EXISTS docs_server_config (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              host TEXT NOT NULL DEFAULT 'localhost',
              port INTEGER NOT NULL DEFAULT 8080,
              auto_start INTEGER NOT NULL DEFAULT 0 CHECK (auto_start IN (0, 1)),
              enabled INTEGER NOT NULL DEFAULT 1 CHECK (enabled IN (0, 1)),
              created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
              updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
            )
          ''');

          // Insert default config
          await database.customStatement('''
            INSERT INTO docs_server_config (host, port, auto_start, enabled, created_at, updated_at)
            VALUES ('localhost', 8080, 0, 1, datetime('now'), datetime('now'))
            ON CONFLICT(id) DO UPDATE SET
              host = excluded.host,
              port = excluded.port,
              auto_start = excluded.auto_start,
              enabled = excluded.enabled,
              updated_at = excluded.updated_at
            WHERE id = 1
          ''');

          _logger.info(
              'docs_server_config table created and default config inserted');
        }
      } catch (createError) {
        _logger
            .severe('Failed to create docs_server_config table: $createError');
      }
    }
  }
}
