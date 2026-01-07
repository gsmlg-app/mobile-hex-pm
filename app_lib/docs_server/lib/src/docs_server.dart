import 'dart:io';

import 'package:app_logging/app_logging.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

import 'index_generator.dart';

/// HTTP server for serving offline Hex documentation.
///
/// This class manages an HTTP server that serves static documentation files
/// from a specified directory. It handles server lifecycle, network address
/// detection, and index file generation.
class DocsServer {
  /// Creates a new [DocsServer] for serving documentation from [docsDir].
  DocsServer({required this.docsDir});

  /// The directory containing documentation files to serve.
  final String docsDir;

  HttpServer? _server;

  /// Returns `true` if the server is currently running.
  bool get isRunning => _server != null;

  /// Starts the HTTP server on the specified [host] and [port].
  ///
  /// Creates the docs directory if it doesn't exist, generates an index file,
  /// and starts serving static files.
  ///
  /// Throws an [Exception] if the server fails to start.
  Future<void> start({required String host, required int port}) async {
    if (_server != null) {
      await stop();
    }

    try {
      final docsDirectory = Directory(docsDir);

      AppLogging.logServerOperation('Starting offline docs server...');
      AppLogging.logServerOperation(
          'Target docs directory: ${docsDirectory.path}');

      // Create directory if it doesn't exist
      if (!await docsDirectory.exists()) {
        AppLogging.logServerOperation(
            'Hex docs directory does not exist, creating...');
        try {
          await docsDirectory.create(recursive: true);
          AppLogging.logServerOperation(
              'Created hex docs directory: ${docsDirectory.path}');

          await IndexGenerator.createDefaultIndex(docsDirectory);
        } catch (e) {
          AppLogging.logServerError('Failed to create docs directory', e);
          throw Exception('Failed to create server directory: $e');
        }
      } else {
        AppLogging.logServerOperation(
            'Hex docs directory already exists: ${docsDirectory.path}');

        // Ensure index.html exists even if directory exists
        try {
          final indexFile = File('${docsDirectory.path}/index.html');
          if (!await indexFile.exists()) {
            AppLogging.logServerOperation(
                'Index file not found, creating default...');
            await IndexGenerator.createDefaultIndex(docsDirectory);
          }
        } catch (e) {
          AppLogging.logServerWarning('Could not check/create index file', e);
        }
      }

      // Create static file handler with directory browsing support
      final handler = createStaticHandler(
        docsDirectory.path,
        defaultDocument: 'index.html',
        listDirectories: true,
      );

      // Count files in directory for logging
      final files = await docsDirectory.list().toList();
      final fileCount = files.whereType<File>().length;
      final dirCount = files.whereType<Directory>().length;

      // Specifically check for index.html
      final indexFile = File('${docsDirectory.path}/index.html');
      final hasIndexFile = await indexFile.exists();

      AppLogging.logServerOperation(
          'Found $fileCount files and $dirCount directories in docs root');
      AppLogging.logServerOperation('Index.html present: $hasIndexFile');

      // Log directory structure
      await _logDirectoryStructure(docsDirectory, files);

      if (!hasIndexFile || dirCount > 0) {
        if (dirCount > 0) {
          AppLogging.logServerOperation(
              'Found $dirCount package directories, creating enhanced index');
        } else {
          AppLogging.logServerWarning('No index.html found',
              'Creating dynamic index file with package listing');
        }
        await IndexGenerator.createDynamicIndex(docsDirectory, files);
      }

      // Start server
      try {
        _server = await shelf_io.serve(handler, host, port);
        AppLogging.logServerOperation(
            'Server started successfully on $host:$port');
      } catch (e) {
        AppLogging.logServerError('Failed to start server on $host:$port', e);
        throw Exception(
            'Failed to start server: Could not bind to $host:$port. Error: $e');
      }

      // Try to get network IP for additional access URL
      String? networkUrl;
      try {
        networkUrl = await getNetworkAddress(host, port);
      } catch (e) {
        AppLogging.logServerWarning('Could not determine network URL', e);
      }

      // Log comprehensive server details
      AppLogging.logServerStart(
        host: host,
        port: port,
        documentRoot: docsDirectory.path,
        localUrl: 'http://$host:$port',
        networkUrl: networkUrl,
        autoStart: false,
        enabled: true,
        fileCount: fileCount,
        directoryCount: dirCount,
      );
    } catch (e) {
      AppLogging.logServerError('start server', e);
      rethrow;
    }
  }

  /// Stops the running HTTP server.
  Future<void> stop() async {
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

  /// Gets the server address, preferring network IP for local hosts.
  ///
  /// Returns `null` if the server is not running or address cannot be determined.
  Future<String?> getServerAddress(String host, int port) async {
    if (_server == null) {
      AppLogging.logServerWarning(
          'Server is null when getting address', 'Server instance is null');
      return null;
    }

    try {
      final fallbackUrl = 'http://$host:$port';

      if (host == 'localhost' || host == '127.0.0.1') {
        try {
          final info = NetworkInfo();
          final wifiIP = await info.getWifiIP();
          if (wifiIP != null && wifiIP.isNotEmpty) {
            final networkUrl = 'http://$wifiIP:$port';
            AppLogging.logServerOperation('Network URL detected: $networkUrl');
            return networkUrl;
          } else {
            AppLogging.logServerWarning(
                'Could not get WiFi IP', 'WiFi IP is null or empty');
          }
        } catch (e) {
          AppLogging.logServerWarning('Failed to get WiFi IP address', e);
        }
      }

      AppLogging.logServerOperation('Using fallback server URL: $fallbackUrl');
      return fallbackUrl;
    } catch (e) {
      AppLogging.logServerWarning('Failed to get server address', e);
      return 'http://$host:$port';
    }
  }

  /// Gets the network address for external access.
  ///
  /// For localhost bindings, attempts to discover the WiFi IP address.
  Future<String?> getNetworkAddress(String host, int port) async {
    try {
      if (host == 'localhost' || host == '127.0.0.1') {
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

  Future<void> _logDirectoryStructure(
    Directory docsDir,
    List<FileSystemEntity> files,
  ) async {
    AppLogging.logServerOperation('=== DETAILED DIRECTORY STRUCTURE ===');
    AppLogging.logServerOperation('Base directory: ${docsDir.path}');
    AppLogging.logServerOperation(
        'Directory exists: ${await docsDir.exists()}');
    AppLogging.logServerOperation(
        'Directory is readable: ${await _isDirectoryReadable(docsDir)}');

    for (final entity in files) {
      if (entity is Directory) {
        AppLogging.logServerOperation('Directory: ${entity.path}');
        try {
          final subFiles = await entity.list().toList();
          final subFileCount = subFiles.whereType<File>().length;
          final subDirCount = subFiles.whereType<Directory>().length;
          AppLogging.logServerOperation(
              '  - $subFileCount files, $subDirCount subdirectories');

          for (final subEntity in subFiles.take(5)) {
            if (subEntity is File) {
              AppLogging.logServerOperation(
                  '    File: ${p.basename(subEntity.path)}');
            } else if (subEntity is Directory) {
              AppLogging.logServerOperation(
                  '    Dir: ${p.basename(subEntity.path)}/');
            }
          }
          if (subFiles.length > 5) {
            AppLogging.logServerOperation(
                '    ... and ${subFiles.length - 5} more items');
          }
        } catch (e) {
          AppLogging.logServerWarning(
              'Could not list subdirectory contents', '${entity.path}: $e');
        }
      } else if (entity is File) {
        AppLogging.logServerOperation(
            'File: ${entity.path} (${await entity.length()} bytes)');
      }
    }
    AppLogging.logServerOperation('=== END DIRECTORY STRUCTURE ===');
  }

  Future<bool> _isDirectoryReadable(Directory dir) async {
    try {
      await dir.list().take(1).toList();
      return true;
    } catch (e) {
      return false;
    }
  }
}
