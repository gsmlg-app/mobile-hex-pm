part of 'bloc.dart';

sealed class HexSearchEvent {
  const HexSearchEvent();
}

final class HexSearchEventInit extends HexSearchEvent {
  const HexSearchEventInit();
}

final class HexSearchEventSearch extends HexSearchEvent {
  final String name;
  const HexSearchEventSearch(this.name);
}

final class HexSearchEventGetPackageOwner extends HexSearchEvent {
  final String name;
  const HexSearchEventGetPackageOwner(this.name);
}

final class HexSearchEventGetPackageRelease extends HexSearchEvent {
  final String name;
  final String version;
  const HexSearchEventGetPackageRelease(this.name, this.version);
}
