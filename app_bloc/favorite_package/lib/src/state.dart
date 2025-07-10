part of 'bloc.dart';

class FavoritePackageState extends Equatable {
  factory FavoritePackageState.initial() {
    return FavoritePackageState();
  }

  const FavoritePackageState({this.favorites = const []});

  final List<FavoritePackageData> favorites;

  @override
  List<Object> get props => [favorites];

  FavoritePackageState copyWith({
    List<FavoritePackageData>? favorites,
  }) {
    return FavoritePackageState(
      favorites: favorites ?? this.favorites,
    );
  }
}
