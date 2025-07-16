part of 'bloc.dart';

class FavoritePackageState extends Equatable {
  factory FavoritePackageState.initial() {
    return const FavoritePackageState();
  }

  const FavoritePackageState({
    this.favorites = const [],
    this.favoritePackages = const {},
    this.favoriteReleases = const {},
  });

  final List<FavoritePackageData> favorites;
  final Map<String, Package> favoritePackages;
  final Map<String, Release> favoriteReleases;

  @override
  List<Object> get props => [
        favorites,
        favoritePackages,
        favoriteReleases,
      ];

  FavoritePackageState copyWith({
    List<FavoritePackageData>? favorites,
    Map<String, Package>? favoritePackages,
    Map<String, Release>? favoriteReleases,
  }) {
    return FavoritePackageState(
      favorites: favorites ?? this.favorites,
      favoritePackages: favoritePackages ?? this.favoritePackages,
      favoriteReleases: favoriteReleases ?? this.favoriteReleases,
    );
  }
}
