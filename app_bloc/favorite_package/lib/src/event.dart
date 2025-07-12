part of 'bloc.dart';

sealed class FavoritePackageEvent {
  const FavoritePackageEvent();
}

final class FavoritePackageEventInit extends FavoritePackageEvent {
  const FavoritePackageEventInit();
}

final class FavoritePackageEventGetReleases extends FavoritePackageEvent {
  const FavoritePackageEventGetReleases(this.name);

  final String name;
}
