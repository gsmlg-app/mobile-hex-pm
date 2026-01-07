import 'dart:async';

import 'package:app_database/app_database.dart';
import 'package:app_logging/app_logging.dart';
import 'package:bloc/bloc.dart';
import 'package:docs_server/docs_server.dart';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';

import 'events.dart';
import 'states.dart';

class OfflineDocsServerBloc
    extends Bloc<OfflineDocsServerEvent, OfflineDocsServerState> {
  final AppDatabase _database;
  DocsServer? _server;

  OfflineDocsServerBloc(this._database)
      : super(const OfflineDocsServerInitial()) {
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
      await DatabaseInitializer.ensureServerConfigTableExists(_database);

      final config = await _getOrCreateConfig();
      final status = _server?.isRunning == true
          ? ServerStatus.running
          : ServerStatus.stopped;
      final serverAddress = await _getServerAddress(config.host, config.port);

      AppLogging.logServerOperation(
          'Server configuration loaded successfully: ${config.host}:${config.port}');

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

      final finalServerAddress = serverAddress ?? currentState.config.serverUrl;

      AppLogging.logServerOperation(
          'Server started successfully with address: $finalServerAddress');

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
      await DatabaseInitializer.ensureServerConfigTableExists(_database);

      if (currentState.status == ServerStatus.running) {
        await _stopServer();
      }

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
      final configs =
          await (_database.select(_database.docsServerConfig)..limit(1)).get();

      if (configs.isNotEmpty) {
        final config = configs.first;
        AppLogging.logServerOperation(
            'Found existing server config: ${config.host}:${config.port}');
        return ServerConfig(
          host: config.host,
          port: config.port,
          autoStart: config.autoStart,
          enabled: config.enabled,
          updatedAt: config.updatedAt,
        );
      }

      AppLogging.logServerOperation(
          'No existing server config found, creating default');
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

      AppLogging.logServerOperation(
          'Default server config created successfully');
      return defaultConfig;
    } catch (e) {
      AppLogging.logServerError('getOrCreateConfig database operation', e);
      AppLogging.logServerWarning('Using fallback default config',
          'Database error, using hardcoded defaults');
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
      final existingConfigs =
          await (_database.select(_database.docsServerConfig)..limit(1)).get();

      if (existingConfigs.isNotEmpty) {
        final configId = existingConfigs.first.id;
        await (_database.update(_database.docsServerConfig)
              ..where((tbl) => tbl.id.equals(configId)))
            .write(DocsServerConfigCompanion(
          host: Value(config.host),
          port: Value(config.port),
          autoStart: Value(config.autoStart),
          enabled: Value(config.enabled),
          updatedAt: Value(config.updatedAt),
        ));
        AppLogging.logServerOperation(
            'Server config updated successfully: ${config.host}:${config.port}');
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
        AppLogging.logServerOperation(
            'Server config created successfully: ${config.host}:${config.port}');
      }
    } catch (e) {
      AppLogging.logServerError('updateConfigInDatabase database operation', e);
      throw Exception('Failed to save configuration: $e');
    }
  }

  Future<void> _startServer(ServerConfig config) async {
    final appSupportDir = await getApplicationSupportDirectory();
    final docsDir = '${appSupportDir.path}/hex_docs';

    _server = DocsServer(docsDir: docsDir);
    await _server!.start(host: config.host, port: config.port);
  }

  Future<void> _stopServer() async {
    if (_server != null) {
      await _server!.stop();
      _server = null;
    }
  }

  Future<String?> _getServerAddress(String host, int port) async {
    if (_server == null || !_server!.isRunning) {
      return null;
    }
    return _server!.getServerAddress(host, port);
  }

  @override
  Future<void> close() {
    _stopServer();
    return super.close();
  }
}
