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
    this.docs = const [],
    this.error,
  });

  final DocStats stats;
  final String indexFile;
  final List<DocInfo> docs;
  final Object? error;

  @override
  List<Object?> get props => [stats, indexFile, docs, error];

  HexDocState copyWith({
    DocStats? stats,
    String? indexFile,
    List<DocInfo>? docs,
    Object? error,
  }) {
    return HexDocState(
      stats: stats ?? this.stats,
      indexFile: indexFile ?? this.indexFile,
      docs: docs ?? this.docs,
      error: error ?? this.error,
    );
  }
}
