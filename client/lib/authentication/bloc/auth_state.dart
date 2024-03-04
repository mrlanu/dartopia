part of 'auth_bloc.dart';

sealed class AuthState{}

final class UnknownState extends AuthState{}
final class AuthenticatedState extends AuthState{}
final class UnauthenticatedState extends AuthState{}

