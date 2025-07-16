part of 'bloc.dart';

sealed class HexDocEvent {
  const HexDocEvent();
}

final class HexDocEventInit extends HexDocEvent {
  const HexDocEventInit();
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
