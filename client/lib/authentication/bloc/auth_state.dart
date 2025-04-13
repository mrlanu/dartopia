part of 'auth_bloc.dart';

sealed class AuthState {
  const AuthState();

  User? get user => switch (this) {
    AuthenticatedState(:final user) => user,
    _ => null,
  };
}

class UnknownState extends AuthState {
  const UnknownState();
}

class AuthenticatedState extends AuthState {
  @override
  final User user;
  const AuthenticatedState(this.user);
}

class UnauthenticatedState extends AuthState {
  const UnauthenticatedState();
}
