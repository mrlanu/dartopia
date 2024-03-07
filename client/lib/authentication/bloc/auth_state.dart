part of 'auth_bloc.dart';

sealed class AuthState extends Equatable{

  @override
  List<Object> get props => [];
}

final class UnknownState extends AuthState{}
final class AuthenticatedState extends AuthState{}
final class UnauthenticatedState extends AuthState{}

