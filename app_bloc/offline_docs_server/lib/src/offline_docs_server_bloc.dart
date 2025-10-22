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

      // Ensure we always have a valid server address
      final finalServerAddress = serverAddress ?? currentState.config.serverUrl;

      AppLogging.logServerOperation('Server started successfully with address: $finalServerAddress');

      emit(currentState.copyWith(
        status: ServerStatus.running,
        errorMessage: null,
        serverAddress: finalServerAddress,
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
        try {
          await docsDir.create(recursive: true);
          AppLogging.logServerOperation('✅ Created hex docs directory: ${docsDir.path}');

          // Create a default index.html file
          await _createDefaultIndexFile(docsDir);
        } catch (e) {
          AppLogging.logServerError('Failed to create docs directory', e);
          throw Exception('Failed to create server directory: $e');
        }
      } else {
        AppLogging.logServerOperation('✅ Hex docs directory already exists: ${docsDir.path}');

        // Ensure index.html exists even if directory exists
        try {
          final indexFile = File('${docsDir.path}/index.html');
          if (!await indexFile.exists()) {
            AppLogging.logServerOperation('Index file not found, creating default...');
            await _createDefaultIndexFile(docsDir);
          }
        } catch (e) {
          AppLogging.logServerWarning('Could not check/create index file', e);
        }
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

      // Specifically check for index.html
      final indexFile = File('${docsDir.path}/index.html');
      final hasIndexFile = await indexFile.exists();

      AppLogging.logServerOperation('Found $fileCount files and $dirCount directories in docs root');
      AppLogging.logServerOperation('Index.html present: $hasIndexFile');

      if (!hasIndexFile) {
        AppLogging.logServerWarning('No index.html found', 'Creating default index file');
        await _createDefaultIndexFile(docsDir);
      }

      // Start server
      try {
        _server = await shelf_io.serve(
          handler,
          config.host,
          config.port,
        );
        AppLogging.logServerOperation('✅ Server started successfully on ${config.host}:${config.port}');
      } catch (e) {
        AppLogging.logServerError('Failed to start server on ${config.host}:${config.port}', e);
        throw Exception('Failed to start server: Could not bind to ${config.host}:${config.port}. Error: $e');
      }

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
    if (_server == null) {
      AppLogging.logServerWarning('Server is null when getting address', 'Server instance is null');
      return null;
    }

    try {
      // Always provide a fallback URL using the configured host and port
      String fallbackUrl = 'http://$host:$port';

      if (host == 'localhost' || host == '127.0.0.1') {
        // Try to get local IP address for network access
        try {
          final info = NetworkInfo();
          final wifiIP = await info.getWifiIP();
          if (wifiIP != null && wifiIP.isNotEmpty) {
            String networkUrl = 'http://$wifiIP:$port';
            AppLogging.logServerOperation('Network URL detected: $networkUrl');
            return networkUrl;
          } else {
            AppLogging.logServerWarning('Could not get WiFi IP', 'WiFi IP is null or empty');
          }
        } catch (e) {
          AppLogging.logServerWarning('Failed to get WiFi IP address', e);
        }
      }

      AppLogging.logServerOperation('Using fallback server URL: $fallbackUrl');
      return fallbackUrl;
    } catch (e) {
      AppLogging.logServerWarning('Failed to get server address', e);
      // Always return a valid URL even if there's an error
      return 'http://$host:$port';
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
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem;
            line-height: 1.6;
            color: #333;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            text-align: center;
            background: white;
            padding: 3rem;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            max-width: 600px;
            width: 100%;
        }
        .logo {
            font-size: 4rem;
            margin-bottom: 1.5rem;
            animation: bounce 2s infinite;
        }
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
            40% { transform: translateY(-10px); }
            60% { transform: translateY(-5px); }
        }
        h1 {
            color: #2c3e50;
            margin-bottom: 1rem;
            font-size: 2.5rem;
            font-weight: 700;
        }
        .info {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 2rem;
            border-radius: 15px;
            margin: 2rem 0;
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        .info h3 {
            margin-bottom: 1rem;
            font-size: 1.5rem;
        }
        .info p {
            margin-bottom: 0.5rem;
            opacity: 0.9;
        }
        .placeholder {
            background: #f8f9fa;
            color: #6c757d;
            padding: 2rem;
            border-radius: 15px;
            margin: 2rem 0;
            border: 2px dashed #dee2e6;
        }
        .placeholder p {
            margin-bottom: 1rem;
            font-size: 1.1rem;
        }
        .status {
            background: #e8f5e8;
            color: #28a745;
            padding: 1rem;
            border-radius: 10px;
            margin: 1rem 0;
            border-left: 4px solid #28a745;
            font-weight: 600;
        }
        .url-display {
            background: #2c3e50;
            color: #fff;
            padding: 1rem;
            border-radius: 10px;
            font-family: 'Courier New', monospace;
            font-size: 1.1rem;
            margin: 1rem 0;
            word-break: break-all;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.1);
        }
        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
            margin: 2rem 0;
        }
        .feature {
            background: white;
            padding: 1.5rem;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border-left: 4px solid #667eea;
        }
        .feature h4 {
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }
        .feature p {
            color: #6c757d;
            font-size: 0.9rem;
        }
        @media (max-width: 768px) {
            body { padding: 1rem; }
            .container { padding: 2rem; }
            h1 { font-size: 2rem; }
            .logo { font-size: 3rem; }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">📚</div>
        <h1>Hex Documentation Server</h1>

        <div class="status">
            ✅ Server is running successfully!
        </div>

        <div class="info">
            <h3>🎉 Welcome to your Hex documentation server!</h3>
            <p>Your server is up and running, ready to serve Hex package documentation.</p>
            <div class="url-display">
                <strong>Server URL:</strong> <span id="server-url"></span>
            </div>
        </div>

        <div class="placeholder">
            <p>📦 <strong>No Hex documentation files found yet?</strong></p>
            <p>Don't worry! This is normal when you first start the server.</p>
            <p>🌐 <strong>Next steps:</strong></p>
        </div>

        <div class="features">
            <div class="feature">
                <h4>📥 Download Docs</h4>
                <p>Go to the Downloads tab in the app and download Hex package documentation</p>
            </div>
            <div class="feature">
                <h4>🔍 Browse Content</h4>
                <p>Navigate through packages and versions using the server's directory browsing</p>
            </div>
            <div class="feature">
                <h4>📖 View Offline</h4>
                <p>Access documentation files offline through this server URL</p>
            </div>
            <div class="feature">
                <h4>⚡ Quick Access</h4>
                <p>Perfect for offline Hex package documentation viewing on mobile devices</p>
            </div>
        </div>

        <div class="info">
            <h3>💡 Pro Tips:</h3>
            <p>• Use the server's directory browsing to explore available packages</p>
            <p>• Bookmark this URL for quick access to your offline documentation</p>
            <p>• The server automatically detects and serves downloaded Hex docs</p>
        </div>
    </div>

    <script>
        // Display the current server URL and ensure page loads correctly
        document.addEventListener('DOMContentLoaded', function() {
            const serverUrl = window.location.origin;
            const urlElement = document.getElementById('server-url');
            if (urlElement) {
                urlElement.textContent = serverUrl;
            }

            // Ensure the page is visible and properly rendered
            document.body.style.visibility = 'visible';

            // Log for debugging
            console.log('Hex Documentation Server loaded successfully');
            console.log('Server URL:', serverUrl);
        });
    </script>
</body>
</html>''';

        await indexFile.writeAsString(htmlContent);
        AppLogging.logServerOperation('✅ Created default index.html file with welcome page');

        // Verify the file was created successfully
        if (await indexFile.exists() && await indexFile.length() > 0) {
          AppLogging.logServerOperation('✅ Index file verified: ${await indexFile.length()} bytes');
        } else {
          throw Exception('Index file was not created properly');
        }
      } else {
        AppLogging.logServerOperation('ℹ️ Index file already exists, skipping creation');
      }
    } catch (e) {
      AppLogging.logServerError('Failed to create default index.html file', e);
      // Re-throw the error so the server startup can handle it properly
      throw Exception('Failed to create server index file: $e');
    }
  }

  @override
  Future<void> close() {
    _stopServer();
    return super.close();
  }
}