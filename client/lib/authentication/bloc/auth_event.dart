part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class AuthenticationSubscriptionRequested extends AuthEvent {}

final class AuthenticationLogoutPressed extends AuthEvent {}
