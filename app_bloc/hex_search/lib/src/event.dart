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
