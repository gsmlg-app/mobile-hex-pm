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
  }

  Future<void> _onFavoritePackageEventInit(
    FavoritePackageEventInit event,
    Emitter<FavoritePackageState> emitter,
  ) async {
    emitter(state.copyWith());
  }
}
