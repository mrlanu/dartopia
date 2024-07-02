import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(UnknownState()) {
    on<CheckAuthStatus>(_onCheckAuthState);
    on<AuthLogoutRequested>(_onLogout);
  }

  Future<void> _onCheckAuthState(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('token');
    if (accessToken != null && !Jwt.isExpired(accessToken)) {
      emit(AuthenticatedState());
    } else {
      emit(UnauthenticatedState());
    }
  }

  Future<void> _onLogout(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    emit(UnauthenticatedState());
  }
}
