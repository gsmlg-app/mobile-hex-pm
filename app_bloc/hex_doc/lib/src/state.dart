part of 'bloc.dart';

enum DocStats {
  unset,
  downloading,
  extracting,
  ok,
  error;
}

class HexDocState extends Equatable {
  factory HexDocState.initial() {
    return HexDocState();
  }

  const HexDocState({
    this.stats = DocStats.unset,
    this.indexFile = '',
    this.error,
  });

  final DocStats stats;
  final String indexFile;
  final Object? error;

  @override
  List<Object?> get props => [stats, indexFile, error];

  HexDocState copyWith({
    DocStats? stats,
    String? indexFile,
    Object? error,
  }) {
    return HexDocState(
      stats: stats ?? this.stats,
      indexFile: indexFile ?? this.indexFile,
      error: error ?? this.error,
    );
  }
}
