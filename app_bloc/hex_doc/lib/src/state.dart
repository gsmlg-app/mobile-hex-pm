part of 'bloc.dart';

enum DocStats {
  unset,
  downloading,
  extracting,
  ok,
  error;
}

class DocInfo extends Equatable {
  const DocInfo({
    required this.packageName,
    required this.packageVersion,
  });

  final String packageName;
  final String packageVersion;

  @override
  List<Object?> get props => [packageName, packageVersion];
}

class HexDocState extends Equatable {
  factory HexDocState.initial() {
    return const HexDocState();
  }

  const HexDocState({
    this.stats = DocStats.unset,
    this.indexFile = '',
    this.docs = const {},
    this.expandedState = const {},
    this.error,
  });

  final DocStats stats;
  final String indexFile;
  final Map<String, List<DocInfo>> docs;
  final Map<String, bool> expandedState;
  final Object? error;

  @override
  List<Object?> get props => [stats, indexFile, docs, expandedState, error];

  HexDocState copyWith({
    DocStats? stats,
    String? indexFile,
    Map<String, List<DocInfo>>? docs,
    Map<String, bool>? expandedState,
    Object? error,
  }) {
    return HexDocState(
      stats: stats ?? this.stats,
      indexFile: indexFile ?? this.indexFile,
      docs: docs ?? this.docs,
      expandedState: expandedState ?? this.expandedState,
      error: error ?? this.error,
    );
  }
}
