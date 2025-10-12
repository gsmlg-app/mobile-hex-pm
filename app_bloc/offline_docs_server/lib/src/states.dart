import 'package:equatable/equatable.dart';

enum ServerStatus {
  stopped,
  starting,
  running,
  stopping,
  error,
}

class ServerConfig extends Equatable {
  final String host;
  final int port;
  final bool autoStart;
  final bool enabled;
  final DateTime updatedAt;

  const ServerConfig({
    required this.host,
    required this.port,
    required this.autoStart,
    required this.enabled,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [host, port, autoStart, enabled, updatedAt];

  ServerConfig copyWith({
    String? host,
    int? port,
    bool? autoStart,
    bool? enabled,
    DateTime? updatedAt,
  }) {
    return ServerConfig(
      host: host ?? this.host,
      port: port ?? this.port,
      autoStart: autoStart ?? this.autoStart,
      enabled: enabled ?? this.enabled,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get serverUrl => 'http://$host:$port';
}

abstract class OfflineDocsServerState extends Equatable {
  const OfflineDocsServerState();

  @override
  List<Object?> get props => [];
}

class OfflineDocsServerInitial extends OfflineDocsServerState {
  const OfflineDocsServerInitial();
}

class OfflineDocsServerLoadInProgress extends OfflineDocsServerState {
  const OfflineDocsServerLoadInProgress();
}

class OfflineDocsServerLoadSuccess extends OfflineDocsServerState {
  final ServerConfig config;
  final ServerStatus status;
  final String? errorMessage;
  final String? serverAddress;

  const OfflineDocsServerLoadSuccess({
    required this.config,
    required this.status,
    this.errorMessage,
    this.serverAddress,
  });

  @override
  List<Object?> get props => [config, status, errorMessage, serverAddress];

  OfflineDocsServerLoadSuccess copyWith({
    ServerConfig? config,
    ServerStatus? status,
    String? errorMessage,
    String? serverAddress,
  }) {
    return OfflineDocsServerLoadSuccess(
      config: config ?? this.config,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      serverAddress: serverAddress ?? this.serverAddress,
    );
  }
}

class OfflineDocsServerFailure extends OfflineDocsServerState {
  final String error;

  const OfflineDocsServerFailure(this.error);

  @override
  List<Object> get props => [error];
}