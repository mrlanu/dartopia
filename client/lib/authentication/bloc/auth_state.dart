part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState._({
    this.status = AuthStatus.unknown,
    this.token = '',
    this.userId = '',
    this.userName = '',
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(
      {required String token, required String userName, required String userId})
      : this._(
            status: AuthStatus.authenticated,
            token: token,
            userId: userId,
            userName: userName);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  AuthState.fromJson(Map<String, dynamic> json)
      : status = AuthStatus.values.byName(json['status'] as String),
        token = json['token'] as String,
        userId = json['userId'] as String,
        userName = json['userName'] as String;

  final AuthStatus status;
  final String token;
  final String userId;
  final String userName;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'status': status.name,
        'token': token,
        'userId': userId,
        'userName': userName,
      };

  @override
  List<Object> get props => [status, token, userId, userName];
}
