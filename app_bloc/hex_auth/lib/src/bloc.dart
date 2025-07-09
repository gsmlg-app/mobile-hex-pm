import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hex_api/hex_api.dart';
import 'package:hex_auth_bloc/src/interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'event.dart';
part 'state.dart';

class HexAuthBloc extends Bloc<HexAuthEvent, HexAuthState> {
  final HexApi hexApi;
  final SharedPreferences sharedPrefs;

  HexAuthBloc(this.hexApi, this.sharedPrefs) : super(HexAuthState.initial()) {
    on<HexAuthEventInit>(_onHexAuthEventInit);
    on<HexAuthEventLogin>(_onHexAuthEventLogin);
    on<HexAuthEventLogout>(_onHexAuthEventLogout);
  }

  Future<void> _onHexAuthEventInit(
    HexAuthEventInit event,
    Emitter<HexAuthState> emitter,
  ) async {
    final apiKey = sharedPrefs.getString('HEX_API_KEY');

    emitter(state.copyWith(apiKey: apiKey));

    if (apiKey != null) {
      try {
        emitter(state.copyWith(isLoading: true));
        final api = hexApi.getUsersApi();
        final resp = await api.getCurrentUser(
          headers: {
            'Authorization': apiKey,
          },
        );
        emitter(state.copyWith(currenUser: resp.data));
        hexApi.dio.interceptors.add(ApiAuthInterceptor(apiKey));
      } catch (e) {
        emitter(state.copyWith(error: e));
      } finally {
        emitter(state.copyWith(isLoading: false));
      }
    }
  }

  Future<void> _onHexAuthEventLogin(
    HexAuthEventLogin event,
    Emitter<HexAuthState> emitter,
  ) async {
    emitter(state.copyWith(apiKey: event.apiKey));
    try {
      emitter(state.copyWith(isLoading: true));
      final api = hexApi.getUsersApi();
      final resp = await api.getCurrentUser(
        headers: {
          'Authorization': event.apiKey,
        },
      );
      emitter(state.copyWith(currenUser: resp.data, error: ''));
      sharedPrefs.setString('HEX_API_KEY', event.apiKey);
      hexApi.dio.interceptors.add(ApiAuthInterceptor(event.apiKey));
    } on DioException catch (e) {
      emitter(state.copyWith(error: e.message));
    } catch (e) {
      emitter(state.copyWith(error: e));
    } finally {
      emitter(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onHexAuthEventLogout(
    HexAuthEventLogout event,
    Emitter<HexAuthState> emitter,
  ) async {
    emitter(state.copyWith(apiKey: null, currenUser: null));
    sharedPrefs.remove('HEX_API_KEY');
  }
}
