import 'dart:async';
import 'dart:io';

import 'package:app_database/app_database.dart';
import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:logging/logging.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

import 'events.dart';
import 'states.dart';

class OfflineDocsServerBloc
    extends Bloc<OfflineDocsServerEvent, OfflineDocsServerState> {
  final AppDatabase _database;
  final Logger _logger = Logger('OfflineDocsServerBloc');
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

      _logger.info('Server configuration loaded successfully: ${config.host}:${config.port}');

      emit(OfflineDocsServerLoadSuccess(
        config: config,
        status: status,
        serverAddress: serverAddress,
      ));
    } catch (e) {
      _logger.severe('Failed to load server config: $e');
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
      _logger.severe('Failed to start server: $e');
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
      _logger.severe('Failed to stop server: $e');
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

      _logger.info('Configuration saved successfully');

      // Auto-start if enabled
      if (event.autoStart && event.enabled) {
        add(const OfflineDocsServerStarted());
      }
    } catch (e) {
      _logger.severe('Failed to update config: $e');
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
        _logger.info('Found existing server config: ${config.host}:${config.port}');
        return ServerConfig(
          host: config.host,
          port: config.port,
          autoStart: config.autoStart,
          enabled: config.enabled,
          updatedAt: config.updatedAt,
        );
      }

      // Create default config
      _logger.info('No existing server config found, creating default');
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

      _logger.info('Default server config created successfully');
      return defaultConfig;
    } catch (e) {
      _logger.severe('Database error in _getOrCreateConfig: $e');
      // Return hardcoded default config as fallback
      _logger.warning('Using fallback default config');
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
        _logger.info('Server config updated successfully: ${config.host}:${config.port}');
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
        _logger.info('Server config created successfully: ${config.host}:${config.port}');
      }
    } catch (e) {
      _logger.severe('Database error in _updateConfigInDatabase: $e');
      // Re-throw the error so the UI can handle it properly
      throw Exception('Failed to save configuration: $e');
    }
  }

  Future<void> _startServer(ServerConfig config) async {
    if (_server != null) {
      await _stopServer();
    }

    try {
      // Get documents directory
      final appDir = await getApplicationDocumentsDirectory();
      final docsDir = Directory('${appDir.path}/offline_docs');

      _logger.info('Starting offline docs server...');
      _logger.info('Application documents directory: ${appDir.path}');
      _logger.info('Target docs directory: ${docsDir.path}');

      // Create directory if it doesn't exist
      if (!await docsDir.exists()) {
        _logger.info('Directory does not exist, creating...');
        await docsDir.create(recursive: true);
        _logger.info('✅ Created offline docs directory: ${docsDir.path}');

        // Create a default index.html file
        await _createDefaultIndexFile(docsDir);
      } else {
        _logger.info('✅ Directory already exists: ${docsDir.path}');
      }

      // Create static file handler
      final handler = createStaticHandler(docsDir.path);

      // Count files in directory for logging
      final files = await docsDir.list().toList();
      final fileCount = files.where((f) => f is File).length;
      final dirCount = files.where((f) => f is Directory).length;

      _logger.info('Found $fileCount files and $dirCount directories in docs root');

      // Start server
      _server = await shelf_io.serve(
        handler,
        config.host,
        config.port,
      );

      // Print comprehensive server details
      _logger.info('=== OFFLINE DOCS SERVER STARTED ===');
      _logger.info('Server Status: RUNNING');
      _logger.info('Local URL: ${config.serverUrl}');
      _logger.info('Host: ${config.host}');
      _logger.info('Port: ${config.port}');
      _logger.info('Document Root: ${docsDir.path}');
      _logger.info('Auto Start: ${config.autoStart}');
      _logger.info('Server Enabled: ${config.enabled}');

      // Try to get network IP for additional access URL
      try {
        final networkUrl = await _getNetworkServerAddress(config.host, config.port);
        if (networkUrl != null && networkUrl != config.serverUrl) {
          _logger.info('Network URL: $networkUrl');
          _logger.info('Devices on same network can access: $networkUrl');
        }
      } catch (e) {
        _logger.warning('Could not determine network URL: $e');
      }

      _logger.info('=====================================');
    } catch (e) {
      _logger.severe('Failed to start server: $e');
      rethrow;
    }
  }

  Future<void> _stopServer() async {
    if (_server != null) {
      final serverAddress = _server!.address;
      final serverPort = _server!.port;

      await _server!.close();
      _server = null;

      _logger.info('=== OFFLINE DOCS SERVER STOPPED ===');
      _logger.info('Server Status: STOPPED');
      _logger.info('Previously running on: http://$serverAddress:$serverPort');
      _logger.info('=====================================');
    } else {
      _logger.info('Server was not running');
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
      _logger.warning('Failed to get server address: $e');
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
      _logger.warning('Failed to get network server address: $e');
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
    <title>Offline Docs Server</title>
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
        <h1>Offline Documentation Server</h1>

        <div class="info">
            <h3>Welcome to your offline docs server!</h3>
            <p>This server is running and ready to serve your offline documentation files.</p>
            <p><strong>Server URL:</strong> <span id="server-url"></span></p>
        </div>

        <div class="placeholder">
            <p>📝 No documentation files found yet.</p>
            <p>Place your HTML, CSS, JavaScript, or other documentation files in this directory to serve them offline.</p>
        </div>

        <div class="info">
            <h3>How to use:</h3>
            <ul style="text-align: left; max-width: 500px; margin: 0 auto;">
                <li>Add your documentation files to this directory</li>
                <li>Create an <code>index.html</code> file as the main entry point</li>
                <li>Access your files through the server URL</li>
                <li>Perfect for offline documentation viewing</li>
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
        _logger.info('✅ Created default index.html file with welcome page');
      }
    } catch (e) {
      _logger.warning('Failed to create default index.html file: $e');
      // Don't rethrow - the server can still work without the index file
    }
  }

  @override
  Future<void> close() {
    _stopServer();
    return super.close();
  }
}