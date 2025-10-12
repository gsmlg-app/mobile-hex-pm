import 'dart:async';
import 'dart:io';

import 'package:app_database/app_database.dart';
import 'package:app_logging/app_logging.dart';
import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

import 'events.dart';
import 'states.dart';

class OfflineDocsServerBloc
    extends Bloc<OfflineDocsServerEvent, OfflineDocsServerState> {
  final AppDatabase _database;
  HttpServer? _server;

  OfflineDocsServerBloc(this._database) : super(const OfflineDocsServerInitial()) {
    on<OfflineDocsServerConfigRequested>(_onConfigRequested);
    on<OfflineDocsServerStatusRequested>(_onStatusRequested);
    on<OfflineDocsServerStarted>(_onStarted);
    on<OfflineDocsServerStopped>(_onStopped);
    on<OfflineDocsServerConfigUpdated>(_onConfigUpdated);
  }

  Future<void> _onConfigRequested(
    OfflineDocsServerConfigRequested event,
    Emitter<OfflineDocsServerState> emit,
  ) async {
    emit(const OfflineDocsServerLoadInProgress());
    try {
      // Ensure the table exists
      await DatabaseInitializer.ensureServerConfigTableExists(_database);

      final config = await _getOrCreateConfig();
      final status = _server != null ? ServerStatus.running : ServerStatus.stopped;
      final serverAddress = await _getServerAddress(config.host, config.port);

      AppLogging.logServerOperation('Server configuration loaded successfully: ${config.host}:${config.port}');

      emit(OfflineDocsServerLoadSuccess(
        config: config,
        status: status,
        serverAddress: serverAddress,
      ));
    } catch (e) {
      AppLogging.logServerError('load server config', e);
      emit(OfflineDocsServerFailure('Failed to load configuration: $e'));
    }
  }

  Future<void> _onStatusRequested(
    OfflineDocsServerStatusRequested event,
    Emitter<OfflineDocsServerState> emit,
  ) async {
    if (state is! OfflineDocsServerLoadSuccess) return;

    final currentState = state as OfflineDocsServerLoadSuccess;
    final serverAddress = await _getServerAddress(
      currentState.config.host,
      currentState.config.port,
    );

    emit(currentState.copyWith(serverAddress: serverAddress));
  }

  Future<void> _onStarted(
    OfflineDocsServerStarted event,
    Emitter<OfflineDocsServerState> emit,
  ) async {
    if (state is! OfflineDocsServerLoadSuccess) return;

    final currentState = state as OfflineDocsServerLoadSuccess;
    if (!currentState.config.enabled) return;

    try {
      emit(currentState.copyWith(status: ServerStatus.starting));

      await _startServer(currentState.config);

      final serverAddress = await _getServerAddress(
        currentState.config.host,
        currentState.config.port,
      );

      emit(currentState.copyWith(
        status: ServerStatus.running,
        errorMessage: null,
        serverAddress: serverAddress,
      ));
    } catch (e) {
      AppLogging.logServerError('start server', e);
      emit(currentState.copyWith(
        status: ServerStatus.error,
        errorMessage: 'Failed to start server: $e',
      ));
    }
  }

  Future<void> _onStopped(
    OfflineDocsServerStopped event,
    Emitter<OfflineDocsServerState> emit,
  ) async {
    if (state is! OfflineDocsServerLoadSuccess) return;

    final currentState = state as OfflineDocsServerLoadSuccess;

    try {
      emit(currentState.copyWith(status: ServerStatus.stopping));
      await _stopServer();

      emit(currentState.copyWith(
        status: ServerStatus.stopped,
        errorMessage: null,
        serverAddress: null,
      ));
    } catch (e) {
      AppLogging.logServerError('stop server', e);
      emit(currentState.copyWith(
        status: ServerStatus.error,
        errorMessage: 'Failed to stop server: $e',
      ));
    }
  }

  Future<void> _onConfigUpdated(
    OfflineDocsServerConfigUpdated event,
    Emitter<OfflineDocsServerState> emit,
  ) async {
    if (state is! OfflineDocsServerLoadSuccess) return;

    final currentState = state as OfflineDocsServerLoadSuccess;

    try {
      // Ensure the table exists
      await DatabaseInitializer.ensureServerConfigTableExists(_database);

      // Stop server if running
      if (currentState.status == ServerStatus.running) {
        await _stopServer();
      }

      // Update config
      final updatedConfig = currentState.config.copyWith(
        host: event.host,
        port: event.port,
        autoStart: event.autoStart,
        enabled: event.enabled,
        updatedAt: DateTime.now(),
      );

      await _updateConfigInDatabase(updatedConfig);

      emit(currentState.copyWith(
        config: updatedConfig,
        status: ServerStatus.stopped,
        errorMessage: null,
        serverAddress: null,
      ));

      AppLogging.logConfigUpdate(
        host: event.host,
        port: event.port,
        autoStart: event.autoStart,
        enabled: event.enabled,
      );

      // Auto-start if enabled
      if (event.autoStart && event.enabled) {
        add(const OfflineDocsServerStarted());
      }
    } catch (e) {
      AppLogging.logServerError('update config', e);
      emit(currentState.copyWith(
        status: ServerStatus.error,
        errorMessage: 'Failed to update configuration: $e',
      ));
    }
  }

  Future<ServerConfig> _getOrCreateConfig() async {
    try {
      final configs = await (_database.select(_database.docsServerConfig)..limit(1)).get();

      if (configs.isNotEmpty) {
        final config = configs.first;
        AppLogging.logServerOperation('Found existing server config: ${config.host}:${config.port}');
        return ServerConfig(
          host: config.host,
          port: config.port,
          autoStart: config.autoStart,
          enabled: config.enabled,
          updatedAt: config.updatedAt,
        );
      }

      // Create default config
      AppLogging.logServerOperation('No existing server config found, creating default');
      final defaultConfig = ServerConfig(
        host: 'localhost',
        port: 8080,
        autoStart: false,
        enabled: true,
        updatedAt: DateTime.now(),
      );

      await _database.into(_database.docsServerConfig).insert(
        DocsServerConfigCompanion.insert(
          host: Value(defaultConfig.host),
          port: Value(defaultConfig.port),
          autoStart: Value(defaultConfig.autoStart),
          enabled: Value(defaultConfig.enabled),
        ),
      );

      AppLogging.logServerOperation('Default server config created successfully');
      return defaultConfig;
    } catch (e) {
      AppLogging.logServerError('getOrCreateConfig database operation', e);
      // Return hardcoded default config as fallback
      AppLogging.logServerWarning('Using fallback default config', 'Database error, using hardcoded defaults');
      return ServerConfig(
        host: 'localhost',
        port: 8080,
        autoStart: false,
        enabled: true,
        updatedAt: DateTime.now(),
      );
    }
  }

  Future<void> _updateConfigInDatabase(ServerConfig config) async {
    try {
      final existingConfigs = await (_database.select(_database.docsServerConfig)..limit(1)).get();

      if (existingConfigs.isNotEmpty) {
        final configId = existingConfigs.first.id;
        await (_database.update(_database.docsServerConfig)..where((tbl) => tbl.id.equals(configId)))
            .write(DocsServerConfigCompanion(
          host: Value(config.host),
          port: Value(config.port),
          autoStart: Value(config.autoStart),
          enabled: Value(config.enabled),
          updatedAt: Value(config.updatedAt),
        ));
        AppLogging.logServerOperation('Server config updated successfully: ${config.host}:${config.port}');
      } else {
        await _database.into(_database.docsServerConfig).insert(
          DocsServerConfigCompanion.insert(
            host: Value(config.host),
            port: Value(config.port),
            autoStart: Value(config.autoStart),
            enabled: Value(config.enabled),
            updatedAt: Value(config.updatedAt),
          ),
        );
        AppLogging.logServerOperation('Server config created successfully: ${config.host}:${config.port}');
      }
    } catch (e) {
      AppLogging.logServerError('updateConfigInDatabase database operation', e);
      // Re-throw the error so the UI can handle it properly
      throw Exception('Failed to save configuration: $e');
    }
  }

  Future<void> _startServer(ServerConfig config) async {
    if (_server != null) {
      await _stopServer();
    }

    try {
      // Get app support directory where hex docs are stored
      final appSupportDir = await getApplicationSupportDirectory();
      final docsDir = Directory('${appSupportDir.path}/hex_docs');

      AppLogging.logServerOperation('Starting offline docs server...');
      AppLogging.logServerOperation('Application support directory: ${appSupportDir.path}');
      AppLogging.logServerOperation('Target docs directory: ${docsDir.path}');

      // Create directory if it doesn't exist
      if (!await docsDir.exists()) {
        AppLogging.logServerOperation('Hex docs directory does not exist, creating...');
        await docsDir.create(recursive: true);
        AppLogging.logServerOperation('✅ Created hex docs directory: ${docsDir.path}');

        // Create a default index.html file
        await _createDefaultIndexFile(docsDir);
      } else {
        AppLogging.logServerOperation('✅ Hex docs directory already exists: ${docsDir.path}');
      }

      // Create static file handler with directory browsing support
      final handler = createStaticHandler(
        docsDir.path,
        defaultDocument: 'index.html',
        listDirectories: true,
      );

      // Count files in directory for logging
      final files = await docsDir.list().toList();
      final fileCount = files.whereType<File>().length;
      final dirCount = files.whereType<Directory>().length;

      AppLogging.logServerOperation('Found $fileCount files and $dirCount directories in docs root');

      // Start server
      _server = await shelf_io.serve(
        handler,
        config.host,
        config.port,
      );

      // Try to get network IP for additional access URL
      String? networkUrl;
      try {
        networkUrl = await _getNetworkServerAddress(config.host, config.port);
      } catch (e) {
        AppLogging.logServerWarning('Could not determine network URL', e);
      }

      // Log comprehensive server details using app_logging
      AppLogging.logServerStart(
        host: config.host,
        port: config.port,
        documentRoot: docsDir.path,
        localUrl: config.serverUrl,
        networkUrl: networkUrl,
        autoStart: config.autoStart,
        enabled: config.enabled,
        fileCount: fileCount,
        directoryCount: dirCount,
      );
    } catch (e) {
      AppLogging.logServerError('start server', e);
      rethrow;
    }
  }

  Future<void> _stopServer() async {
    if (_server != null) {
      final serverAddress = _server!.address;
      final serverPort = _server!.port;
      final previousUrl = 'http://$serverAddress:$serverPort';

      await _server!.close();
      _server = null;

      AppLogging.logServerStop(previousUrl: previousUrl);
    } else {
      AppLogging.logServerOperation('Server was not running');
    }
  }

  Future<String?> _getServerAddress(String host, int port) async {
    if (_server == null) return null;

    try {
      if (host == 'localhost' || host == '127.0.0.1') {
        // Get local IP address
        final info = NetworkInfo();
        final wifiIP = await info.getWifiIP();
        if (wifiIP != null) {
          return 'http://$wifiIP:$port';
        }
      }
      return 'http://$host:$port';
    } catch (e) {
      AppLogging.logServerWarning('Failed to get server address', e);
      return null;
    }
  }

  Future<String?> _getNetworkServerAddress(String host, int port) async {
    try {
      if (host == 'localhost' || host == '127.0.0.1') {
        // Get local IP address for network access
        final info = NetworkInfo();
        final wifiIP = await info.getWifiIP();
        if (wifiIP != null) {
          return 'http://$wifiIP:$port';
        }
      }
      return 'http://$host:$port';
    } catch (e) {
      AppLogging.logServerWarning('Failed to get network server address', e);
      return null;
    }
  }

  Future<void> _createDefaultIndexFile(Directory docsDir) async {
    try {
      final indexFile = File('${docsDir.path}/index.html');

      if (!await indexFile.exists()) {
        const htmlContent = '''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hex Documentation Server</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem;
            line-height: 1.6;
            color: #333;
        }
        .container {
            text-align: center;
        }
        .logo {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
        h1 {
            color: #2c3e50;
            margin-bottom: 1rem;
        }
        .info {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 8px;
            margin: 2rem 0;
            border-left: 4px solid #007bff;
        }
        .placeholder {
            color: #6c757d;
            font-style: italic;
            margin: 2rem 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">📚</div>
        <h1>Hex Documentation Server</h1>

        <div class="info">
            <h3>Welcome to your Hex documentation server!</h3>
            <p>This server is running and ready to serve your downloaded Hex package documentation.</p>
            <p><strong>Server URL:</strong> <span id="server-url"></span></p>
        </div>

        <div class="placeholder">
            <p>📦 No Hex documentation files found yet.</p>
            <p>Download Hex package documentation from the app's Downloads tab to serve them offline.</p>
            <p>🌐 This server supports directory browsing - you can navigate through package and version directories!</p>
        </div>

        <div class="info">
            <h3>How to use:</h3>
            <ul style="text-align: left; max-width: 500px; margin: 0 auto;">
                <li>Download Hex package documentation from the app</li>
                <li>Browse packages and versions through this server</li>
                <li>Access documentation files through the server URL</li>
                <li>Perfect for offline Hex package documentation viewing</li>
            </ul>
        </div>
    </div>

    <script>
        // Display the current server URL
        document.getElementById('server-url').textContent = window.location.origin;
    </script>
</body>
</html>''';

        await indexFile.writeAsString(htmlContent);
        AppLogging.logServerOperation('✅ Created default index.html file with welcome page');
      }
    } catch (e) {
      AppLogging.logServerWarning('Failed to create default index.html file', e);
      // Don't rethrow - the server can still work without the index file
    }
  }

  @override
  Future<void> close() {
    _stopServer();
    return super.close();
  }
}