import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cache_client/cache_client.dart';
import 'package:jwt_decode/jwt_decode.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({CacheClient? cacheClient,
  })  : _cacheClient = cacheClient ?? CacheClient.instance,
        super(UnauthenticatedState()) {
    on<CheckAuthStatus>(_onCheckAuthState);
    on<AuthLogoutRequested>(_onLogout);
  }

  final CacheClient _cacheClient;

  Future<void> _onCheckAuthState(CheckAuthStatus event, Emitter<AuthState> emit) async {
    final accessToken = await _cacheClient.getAccessToken();
    if (accessToken != null && !Jwt.isExpired(accessToken)) {
      emit(AuthenticatedState());
    } else {
      emit(UnauthenticatedState());
    }
  }

  Future<void> _onLogout(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await _cacheClient.deleteAccessToken();
    emit(UnauthenticatedState());
  }
}
