import 'app_logger.dart';

/// Wrapper class that provides static methods for server logging
/// This maintains compatibility with the existing AppLogging interface
class AppLogging {
  static final AppLogger _logger = AppLogger();

  /// Log server start with details
  static void logServerStart({
    required String host,
    required int port,
    required String documentRoot,
    required String localUrl,
    String? networkUrl,
    required bool autoStart,
    required bool enabled,
    required int fileCount,
    required int directoryCount,
  }) {
    _logger.i('=== OFFLINE DOCS SERVER STARTED ===');
    _logger.i('Server Status: RUNNING');
    _logger.i('Local URL: $localUrl');
    _logger.i('Host: $host');
    _logger.i('Port: $port');
    _logger.i('Document Root: $documentRoot');
    _logger.i('Auto Start: $autoStart');
    _logger.i('Server Enabled: $enabled');
    _logger.i('Files: $fileCount, Directories: $directoryCount');

    if (networkUrl != null && networkUrl != localUrl) {
      _logger.i('Network URL: $networkUrl');
      _logger.i('Devices on same network can access: $networkUrl');
    }

    _logger.i('=====================================');
  }

  /// Log server stop
  static void logServerStop({
    required String previousUrl,
  }) {
    _logger.i('=== OFFLINE DOCS SERVER STOPPED ===');
    _logger.i('Server Status: STOPPED');
    _logger.i('Previously running on: $previousUrl');
    _logger.i('=====================================');
  }

  /// Log user access to server
  static void logServerAccess({
    required String method,
    required String path,
    required String userAgent,
    required String remoteAddress,
    int? statusCode,
    int? contentLength,
  }) {
    _logger.i('Server Access: $method $path from $remoteAddress');
    _logger.i('User-Agent: $userAgent');
    if (statusCode != null) {
      _logger.i(
          'Status: $statusCode${contentLength != null ? ', Size: $contentLength bytes' : ''}');
    }
  }

  /// Log server configuration changes
  static void logConfigUpdate({
    required String host,
    required int port,
    required bool autoStart,
    required bool enabled,
  }) {
    _logger.i('Configuration updated: $host:$port');
    _logger.i('Auto Start: $autoStart, Enabled: $enabled');
  }

  /// Log server operations
  static void logServerOperation(String operation, {String? details}) {
    if (details != null) {
      _logger.i('$operation: $details');
    } else {
      _logger.i(operation);
    }
  }

  /// Log server errors
  static void logServerError(String operation, dynamic error,
      [StackTrace? stackTrace]) {
    _logger.e('Server error in $operation: $error', error, stackTrace);
  }

  /// Log server warnings
  static void logServerWarning(String operation, dynamic error) {
    _logger.w('Server warning in $operation: $error');
  }
}
