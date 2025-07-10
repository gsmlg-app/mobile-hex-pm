part of 'bloc.dart';

class HexSearchState extends Equatable {
  factory HexSearchState.initial() {
    return HexSearchState();
  }

  const HexSearchState({
    this.results = const [],
    this.isLoading = false,
  });

  final List<Package> results;

  final bool isLoading;

  @override
  List<Object> get props => [results, isLoading];

  HexSearchState copyWith({bool? isLoading, List<Package>? results}) {
    return HexSearchState(
      isLoading: isLoading ?? this.isLoading,
      results: results ?? this.results,
    );
  }
}
