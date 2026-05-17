import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:network/network.dart';

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
  StreamSubscription<void>? _sessionExpiredSubscription;

  Future<void> _onSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _sessionExpiredSubscription?.cancel();
    _sessionExpiredSubscription =
        SessionNotifier.instance.onSessionExpired.listen((_) {
      _authenticationRepository.sessionExpired();
    });

    await emit.onEach(
      _authenticationRepository.authStatus,
      onData: (status) {
        switch (status) {
          case UnauthenticatedStatus():
            emit(const UnauthenticatedState());
          case AuthenticatedStatus(:final user):
            emit(AuthenticatedState(user));
          case UnknownStatus():
            emit(const UnauthenticatedState());
        }
      },
      onError: addError,
    );
  }

  Future<void> _onLogout(
    AuthenticationLogoutPressed event,
    Emitter<AuthState> emit,
  ) async {
    await _authenticationRepository.logout();
    emit(const UnauthenticatedState());
  }

  @override
  Future<void> close() {
    _sessionExpiredSubscription?.cancel();
    return super.close();
  }
}
