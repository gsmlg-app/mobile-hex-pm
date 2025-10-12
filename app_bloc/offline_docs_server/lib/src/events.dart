import 'package:equatable/equatable.dart';

abstract class OfflineDocsServerEvent extends Equatable {
  const OfflineDocsServerEvent();

  @override
  List<Object> get props => [];
}

class OfflineDocsServerStarted extends OfflineDocsServerEvent {
  const OfflineDocsServerStarted();
}

class OfflineDocsServerStopped extends OfflineDocsServerEvent {
  const OfflineDocsServerStopped();
}

class OfflineDocsServerConfigUpdated extends OfflineDocsServerEvent {
  final String host;
  final int port;
  final bool autoStart;
  final bool enabled;

  const OfflineDocsServerConfigUpdated({
    required this.host,
    required this.port,
    required this.autoStart,
    required this.enabled,
  });

  @override
  List<Object> get props => [host, port, autoStart, enabled];
}

class OfflineDocsServerStatusRequested extends OfflineDocsServerEvent {
  const OfflineDocsServerStatusRequested();
}

class OfflineDocsServerConfigRequested extends OfflineDocsServerEvent {
  const OfflineDocsServerConfigRequested();
}