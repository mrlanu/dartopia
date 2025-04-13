import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepo authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const UnknownState()) {
    on<AuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthenticationLogoutPressed>(_onLogout);
  }

  final AuthRepo _authenticationRepository;

  Future<void> _onSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthState> emit,
  ) {
    return emit.onEach(
      _authenticationRepository.authStatus,
      onData: (status) async {
        switch (status) {
          case UnauthenticatedStatus():
            return emit(const UnauthenticatedState());
          case AuthenticatedStatus(:final user):
            return emit(AuthenticatedState(user));
          case UnknownStatus():
            return emit(const UnauthenticatedState());
        }
      },
      onError: addError,
    );
  }

  /*Future<void> _onCheckAuthState(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('token');
    if (accessToken != null && !Jwt.isExpired(accessToken)) {
      emit(AuthenticatedState());
    } else {
      emit(UnauthenticatedState());
    }
  }*/

  Future<void> _onLogout(
      AuthenticationLogoutPressed event, Emitter<AuthState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    emit(const UnauthenticatedState());
  }
}
