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
    on<FavoritePackageEventGetReleases>(_onFavoritePackageEventGetReleases);
  }

  Future<void> _onFavoritePackageEventInit(
    FavoritePackageEventInit event,
    Emitter<FavoritePackageState> emitter,
  ) async {
    final List<FavoritePackageData> favorites =
        await database.select(database.favoritePackage).get();

    emitter(state.copyWith(favorites: favorites));
  }

  Future<void> _onFavoritePackageEventGetReleases(
    FavoritePackageEventGetReleases event,
    Emitter<FavoritePackageState> emitter,
  ) async {
    try {
      final name = event.name;
      final pkg = await hexApi.getPackagesApi().getPackage(name: name);
      final releases = pkg.data!.releases;
      final list = <Release>[];
      for (var release in releases) {
        final r = await hexApi.getPackageReleasesApi().getRelease(
              name: name,
              version: release.version!,
            );
        list.add(r.data!);
      }
      final favoriteReleases = Map<String, List<Release>>.unmodifiable(
        {
          ...state.favoriteReleases,
          name: list,
        },
      );
      emitter(state.copyWith(favoriteReleases: favoriteReleases));
    } catch (e) {
      print(e);
    }
  }
}
