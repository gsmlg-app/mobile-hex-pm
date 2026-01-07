import 'package:app_database/app_database.dart';
import 'package:bloc/bloc.dart';
import 'package:hex_api/hex_api.dart';

import 'event.dart';
import 'state.dart';

class FavoritePackageBloc
    extends Bloc<FavoritePackageEvent, FavoritePackageState> {
  final AppDatabase database;
  final HexApi hexApi;

  FavoritePackageBloc(this.database, this.hexApi)
      : super(FavoritePackageState.initial()) {
    on<FavoritePackageEventInit>(_onFavoritePackageEventInit);
    on<FavoritePackageEventGetPackage>(_onFavoritePackageEventGetPackage);
    on<FavoritePackageEventGetRelease>(_onFavoritePackageEventGetRelease);
    on<FavoritePackageEventRemove>(_onFavoritePackageEventRemove);
    on<FavoritePackageEventResetAll>(_onFavoritePackageEventResetAll);
  }

  Future<void> _onFavoritePackageEventInit(
    FavoritePackageEventInit event,
    Emitter<FavoritePackageState> emitter,
  ) async {
    final List<FavoritePackageData> favorites =
        await database.select(database.favoritePackage).get();

    emitter(state.copyWith(favorites: favorites));
  }

  Future<void> _onFavoritePackageEventGetPackage(
    FavoritePackageEventGetPackage event,
    Emitter<FavoritePackageState> emitter,
  ) async {
    try {
      final name = event.name;
      final pkg = await hexApi.packages.getPackage(name: name);
      final favoritePackages = Map<String, Package>.unmodifiable(
        {
          ...state.favoritePackages,
          name: pkg,
        },
      );
      emitter(state.copyWith(favoritePackages: favoritePackages));
    } catch (e) {
      emitter(state.copyWith(errors: e));
    }
  }

  Future<void> _onFavoritePackageEventGetRelease(
    FavoritePackageEventGetRelease event,
    Emitter<FavoritePackageState> emitter,
  ) async {
    try {
      final name = event.name;
      final version = event.version;
      final release = await hexApi.releases.getRelease(
        name: name,
        version: version,
      );
      final favoriteReleases = Map<String, Release>.unmodifiable(
        {
          ...state.favoriteReleases,
          '$name-$version': release,
        },
      );
      emitter(state.copyWith(favoriteReleases: favoriteReleases));
    } catch (e) {
      emitter(state.copyWith(errors: e));
    }
  }

  Future<void> _onFavoritePackageEventRemove(
    FavoritePackageEventRemove event,
    Emitter<FavoritePackageState> emitter,
  ) async {
    await (database.delete(database.favoritePackage)
          ..where((tbl) => tbl.name.equals(event.name)))
        .go();

    final List<FavoritePackageData> favorites =
        await database.select(database.favoritePackage).get();

    emitter(state.copyWith(favorites: favorites));
  }

  Future<void> _onFavoritePackageEventResetAll(
    FavoritePackageEventResetAll event,
    Emitter<FavoritePackageState> emitter,
  ) async {
    await database.delete(database.favoritePackage).go();

    emitter(state.copyWith(
      favorites: [],
      favoritePackages: {},
      favoriteReleases: {},
    ));
  }
}
