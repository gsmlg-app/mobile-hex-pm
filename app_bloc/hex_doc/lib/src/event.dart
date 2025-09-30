part of 'bloc.dart';

sealed class HexDocEvent extends Equatable {
  const HexDocEvent();

  @override
  List<Object> get props => [];
}

final class HexDocEventInit extends HexDocEvent {
  const HexDocEventInit();
}

final class HexDocEventDelete extends HexDocEvent {
  final String packageName;
  final String packageVersion;

  const HexDocEventDelete({
    required this.packageName,
    required this.packageVersion,
  });

  @override
  List<Object> get props => [packageName, packageVersion];
}

final class HexDocEventToggleExpanded extends HexDocEvent {
  final String packageName;
  const HexDocEventToggleExpanded(this.packageName);

  @override
  List<Object> get props => [packageName];
}

final class HexDocEventList extends HexDocEvent {
  const HexDocEventList();
}

final class HexDocEventSetup extends HexDocEvent {
  final String packageName;
  final String packageVersion;

  const HexDocEventSetup({
    required this.packageName,
    required this.packageVersion,
  });

  @override
  List<Object> get props => [packageName, packageVersion];
}
