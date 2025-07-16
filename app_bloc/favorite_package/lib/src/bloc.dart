import 'package:app_database/app_database.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hex_api/hex_api.dart';

part 'event.dart';
part 'state.dart';

class FavoritePackageBloc
    extends Bloc<FavoritePackageEvent, FavoritePackageState> {
  final AppDatabase database;
  final HexApi hexApi;

  FavoritePackageBloc(this.database, this.hexApi)
      : super(FavoritePackageState.initial()) {
    on<FavoritePackageEventInit>(_onFavoritePackageEventInit);
    on<FavoritePackageEventGetPackage>(_onFavoritePackageEventGetPackage);
    on<FavoritePackageEventGetRelease>(_onFavoritePackageEventGetRelease);
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
      final pkg = await hexApi.getPackagesApi().getPackage(name: name);
      final favoritePackages = Map<String, Package>.unmodifiable(
        {
          ...state.favoritePackages,
          name: pkg.data!,
        },
      );
      emitter(state.copyWith(favoritePackages: favoritePackages));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onFavoritePackageEventGetRelease(
    FavoritePackageEventGetRelease event,
    Emitter<FavoritePackageState> emitter,
  ) async {
    try {
      final name = event.name;
      final version = event.version;
      final release = await hexApi.getPackageReleasesApi().getRelease(
            name: name,
            version: version,
          );
      final favoriteReleases = Map<String, Release>.unmodifiable(
        {
          ...state.favoriteReleases,
          '$name-$version': release.data!,
        },
      );
      emitter(state.copyWith(favoriteReleases: favoriteReleases));
    } catch (e) {
      print(e);
    }
  }
}
