import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:hex_api/hex_api.dart';

part 'event.dart';
part 'form.dart';
part 'state.dart';

class HexSearchBloc extends Bloc<HexSearchEvent, HexSearchState> {
  final HexApi hexApi;

  HexSearchBloc(this.hexApi) : super(HexSearchState.initial()) {
    on<HexSearchEventInit>(_onHexSearchEventInit);
    on<HexSearchEventSearch>(_onHexSearchEventSearch);
  }

  Future<void> _onHexSearchEventInit(
    HexSearchEventInit event,
    Emitter<HexSearchState> emitter,
  ) async {
    emitter(state.copyWith());
  }

  Future<void> _onHexSearchEventSearch(
    HexSearchEventSearch event,
    Emitter<HexSearchState> emitter,
  ) async {
    try {
      emitter(state.copyWith(isLoading: true));
      final api = hexApi.getPackagesApi();
      final resp = await api.listPackages(
        search: event.name,
        sort: 'recent_downloads',
      );
      final data = resp.data;
      emitter(state.copyWith(results: data));
    } catch (e) {
      emitter(state.copyWith(results: []));
    } finally {
      emitter(state.copyWith(isLoading: false));
    }
  }
}
