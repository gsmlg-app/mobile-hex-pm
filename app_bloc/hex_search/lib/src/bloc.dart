import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart' show DioException;
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
    on<HexSearchEventGetPackageOwner>(_onHexSearchEventGetPackageOwner);
    on<HexSearchEventGetPackageRelease>(_onHexSearchEventGetPackageRelease);
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
      emitter(state.copyWith(isLoading: true, error: null));
      final api = hexApi.getPackagesApi();
      final resp = await api.listPackages(
        search: event.name,
        sort: 'recent_downloads',
      );
      final data = resp.data;
      emitter(state.copyWith(results: data ?? []));
    } catch (e) {
      emitter(state.copyWith(
        results: [],
        error: 'Failed to search packages: ${e.toString()}',
      ));
    } finally {
      emitter(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onHexSearchEventGetPackageOwner(
    HexSearchEventGetPackageOwner event,
    Emitter<HexSearchState> emitter,
  ) async {
    try {
      final api = hexApi.getPackageOwnersApi();
      final resp = await api.getOwners(name: event.name);
      final owners = resp.data;
      final stateOwners = Map<String, List<Owner>>.unmodifiable(
        {
          ...state.owners,
          event.name: owners ?? <Owner>[],
        },
      );
      emitter(state.copyWith(owners: stateOwners));
    } on DioException catch (e) {
      print(e.message);
    } catch (e) {
      print(e);
    }
  }

  void _onHexSearchEventGetPackageRelease(
    HexSearchEventGetPackageRelease event,
    Emitter<HexSearchState> emitter,
  ) async {
    try {
      final api = hexApi.getPackageReleasesApi();
      final resp = await api.getRelease(
        name: event.name,
        version: event.version,
      );
      final release = resp.data;
      final stateReleases = Map<String, Release>.unmodifiable(
        {
          ...state.releases,
          event.name: release!,
        },
      );
      emitter(state.copyWith(releases: stateReleases));
    } on DioException catch (e, s) {
      print(e.message);
      print(e.requestOptions.uri);
      print(e.response?.data);
      print(e.response?.statusCode);
      print(e.response?.statusMessage);
      print(e);
      print(s);
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
