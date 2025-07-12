part of 'bloc.dart';

class FavoritePackageState extends Equatable {
  factory FavoritePackageState.initial() {
    return FavoritePackageState();
  }

  const FavoritePackageState(
      {this.favorites = const [], this.favoriteReleases = const {}});

  final List<FavoritePackageData> favorites;

  final Map<String, List<Release>> favoriteReleases;

  @override
  List<Object> get props => [favorites, favoriteReleases];

  FavoritePackageState copyWith({
    List<FavoritePackageData>? favorites,
    Map<String, List<Release>>? favoriteReleases,
  }) {
    return FavoritePackageState(
      favorites: favorites ?? this.favorites,
      favoriteReleases: favoriteReleases ?? this.favoriteReleases,
    );
  }
}
