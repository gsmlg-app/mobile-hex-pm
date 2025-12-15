sealed class FavoritePackageEvent {
  const FavoritePackageEvent();
}

final class FavoritePackageEventInit extends FavoritePackageEvent {
  const FavoritePackageEventInit();
}

final class FavoritePackageEventGetPackage extends FavoritePackageEvent {
  final String name;

  const FavoritePackageEventGetPackage(this.name);
}

final class FavoritePackageEventGetRelease extends FavoritePackageEvent {
  final String name;
  final String version;

  const FavoritePackageEventGetRelease(this.name, this.version);
}

final class FavoritePackageEventRemove extends FavoritePackageEvent {
  final String name;

  const FavoritePackageEventRemove(this.name);
}

final class FavoritePackageEventResetAll extends FavoritePackageEvent {
  const FavoritePackageEventResetAll();
}
