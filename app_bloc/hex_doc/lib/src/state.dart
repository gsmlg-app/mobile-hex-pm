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
    this.status = const {},
    this.indexFiles = const {},
    this.docs = const {},
    this.expandedState = const {},
    this.error,
  });

  final Map<String, DocStats> status;
  final Map<String, String> indexFiles;
  final Map<String, List<DocInfo>> docs;
  final Map<String, bool> expandedState;
  final Object? error;

  @override
  List<Object?> get props => [status, indexFiles, docs, expandedState, error];

  HexDocState copyWith({
    Map<String, DocStats>? status,
    Map<String, String>? indexFiles,
    Map<String, List<DocInfo>>? docs,
    Map<String, bool>? expandedState,
    Object? error,
  }) {
    return HexDocState(
      status: status ?? this.status,
      indexFiles: indexFiles ?? this.indexFiles,
      docs: docs ?? this.docs,
      expandedState: expandedState ?? this.expandedState,
      error: error ?? this.error,
    );
  }
}
