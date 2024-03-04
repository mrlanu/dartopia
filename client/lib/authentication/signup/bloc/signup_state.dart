part of 'signup_bloc.dart';

final class SignupState extends Equatable {
  const SignupState({
    this.status = FormzSubmissionStatus.initial,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.errorMessage = '',
    this.isValid = false,
  });

  final FormzSubmissionStatus status;
  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final String errorMessage;
  final bool isValid;

  SignupState copyWith({
    FormzSubmissionStatus? status,
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    String? errorMessage,
    bool? isValid,
  }) {
    return SignupState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      errorMessage: errorMessage ?? this.errorMessage,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props =>
      [status, email, password, confirmedPassword, errorMessage];
}
