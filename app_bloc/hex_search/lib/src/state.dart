part of 'bloc.dart';

class HexSearchState extends Equatable {
  factory HexSearchState.initial() {
    return HexSearchState();
  }

  const HexSearchState({
    this.results = const [],
    this.isLoading = false,
    this.owners = const <String, List<Owner>>{},
    this.releases = const <String, Release>{},
    this.error,
  });

  final List<Package> results;

  final bool isLoading;

  final Map<String, List<Owner>> owners;

  final Map<String, Release> releases;

  final String? error;

  @override
  List<Object> get props => [results, isLoading, owners, releases, error ?? ''];

  HexSearchState copyWith({
    bool? isLoading,
    List<Package>? results,
    Map<String, List<Owner>>? owners,
    Map<String, Release>? releases,
    String? error,
  }) {
    return HexSearchState(
      isLoading: isLoading ?? this.isLoading,
      results: results ?? this.results,
      owners: owners ?? this.owners,
      releases: releases ?? this.releases,
      error: error ?? this.error,
    );
  }
}
