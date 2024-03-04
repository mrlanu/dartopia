part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class AuthLogoutRequested extends AuthEvent {}

final class CheckAuthStatus extends AuthEvent {}
