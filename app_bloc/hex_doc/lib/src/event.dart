part of 'bloc.dart';

sealed class HexDocEvent {
  const HexDocEvent();
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
}

final class HexDocEventToggleExpanded extends HexDocEvent {
  final String packageName;
  const HexDocEventToggleExpanded(this.packageName);
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
}

final class HexDocEventDeleteAll extends HexDocEvent {
  const HexDocEventDeleteAll();
}
