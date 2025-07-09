part of 'bloc.dart';

sealed class HexAuthEvent {
  const HexAuthEvent();
}

final class HexAuthEventInit extends HexAuthEvent {
  const HexAuthEventInit();
}

final class HexAuthEventLogin extends HexAuthEvent {
  final String apiKey;
  const HexAuthEventLogin(this.apiKey);
}

final class HexAuthEventLogout extends HexAuthEvent {
  const HexAuthEventLogout();
}
