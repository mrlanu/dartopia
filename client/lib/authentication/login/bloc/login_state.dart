part of 'login_bloc.dart';

final class LoginState extends Equatable {
  const LoginState({
    this.status = FormzSubmissionStatus.initial,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.errorMessage = '',
    this.isValid = false,
  });

  final FormzSubmissionStatus status;
  final Email email;
  final Password password;
  final String errorMessage;
  final bool isValid;

  LoginState copyWith({
    FormzSubmissionStatus? status,
    Email? email,
    Password? password,
    String? errorMessage,
    bool? isValid,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props => [status, email, password, errorMessage];
}
