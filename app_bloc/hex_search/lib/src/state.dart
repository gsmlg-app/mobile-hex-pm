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
  });

  final List<Package> results;

  final bool isLoading;

  final Map<String, List<Owner>> owners;

  final Map<String, Release> releases;

  @override
  List<Object> get props => [results, isLoading, owners, releases];

  HexSearchState copyWith({
    bool? isLoading,
    List<Package>? results,
    Map<String, List<Owner>>? owners,
    Map<String, Release>? releases,
  }) {
    return HexSearchState(
      isLoading: isLoading ?? this.isLoading,
      results: results ?? this.results,
      owners: owners ?? this.owners,
      releases: releases ?? this.releases,
    );
  }
}
