import 'package:app_secure_storage/app_secure_storage.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hex_api/hex_api.dart';
import 'package:hex_auth_bloc/src/interceptor.dart';

part 'event.dart';
part 'state.dart';

class HexAuthBloc extends Bloc<HexAuthEvent, HexAuthState> {
  final Dio dio;
  final HexApi hexApi;
  final VaultRepository vault;

  HexAuthBloc(this.dio, this.hexApi, this.vault)
      : super(HexAuthState.initial()) {
    on<HexAuthEventInit>(_onHexAuthEventInit);
    on<HexAuthEventLogin>(_onHexAuthEventLogin);
    on<HexAuthEventLogout>(_onHexAuthEventLogout);
  }

  Future<void> _onHexAuthEventInit(
    HexAuthEventInit event,
    Emitter<HexAuthState> emitter,
  ) async {
    final apiKey = await vault.read(key: 'HEX_API_KEY');

    emitter(state.copyWith(apiKey: apiKey));

    if (apiKey != null) {
      try {
        emitter(state.copyWith(isLoading: true));
        // Add auth interceptor before making the authenticated request
        dio.interceptors.add(ApiAuthInterceptor(apiKey));
        final user = await hexApi.users.getCurrentUser();
        emitter(state.copyWith(currenUser: user));
      } catch (e) {
        // Remove interceptor on failure
        dio.interceptors.removeWhere((i) => i is ApiAuthInterceptor);
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
      // Add auth interceptor for this login attempt
      dio.interceptors.add(ApiAuthInterceptor(event.apiKey));
      final user = await hexApi.users.getCurrentUser();
      emitter(state.copyWith(currenUser: user, error: ''));
      await vault.write(key: 'HEX_API_KEY', value: event.apiKey);
    } on DioException catch (e) {
      // Remove interceptor on failure
      dio.interceptors.removeWhere((i) => i is ApiAuthInterceptor);
      emitter(state.copyWith(error: e.message));
    } catch (e) {
      // Remove interceptor on failure
      dio.interceptors.removeWhere((i) => i is ApiAuthInterceptor);
      emitter(state.copyWith(error: e));
    } finally {
      emitter(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onHexAuthEventLogout(
    HexAuthEventLogout event,
    Emitter<HexAuthState> emitter,
  ) async {
    emitter(state.copyWith(clearApiKey: true, clearCurrentUser: true));
    await vault.delete(key: 'HEX_API_KEY');
    dio.interceptors.removeWhere((i) => i is ApiAuthInterceptor);
  }
}
