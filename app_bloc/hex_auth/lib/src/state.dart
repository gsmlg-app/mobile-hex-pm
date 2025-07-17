part of 'bloc.dart';

class HexAuthState extends Equatable {
  factory HexAuthState.initial() {
    return HexAuthState();
  }

  const HexAuthState({
    this.apiKey,
    this.isLoading = false,
    this.currenUser,
    this.error,
  });

  final String? apiKey;

  final bool isLoading;

  final UserWithOrgs? currenUser;

  final Object? error;

  @override
  List<Object?> get props => [apiKey, isLoading, currenUser, error];

  HexAuthState copyWith({
    String? apiKey,
    UserWithOrgs? currenUser,
    bool? isLoading,
    Object? error,
    bool clearApiKey = false,
    bool clearCurrentUser = false,
  }) {
    return HexAuthState(
      apiKey: clearApiKey ? null : apiKey ?? this.apiKey,
      currenUser: clearCurrentUser ? null : currenUser ?? this.currenUser,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
