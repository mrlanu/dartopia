import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import 'package:dartopia/authentication/authentication.dart';
import 'package:models/models.dart';
import 'package:network/network.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthRepo authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<ResetStatus>(_onResetStatus);
  }

  final AuthRepo _authenticationRepository;

  void _onEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([state.password, email]),
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([password, state.email]),
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      final response = await _login(
          email: state.email.value, password: state.password.value);
      response.fold(
        (failure) => emit(
          state.copyWith(
              status: FormzSubmissionStatus.failure,
              errorMessage: failure.message),
        ),
        (success) => emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
          ),
        ),
      );
    }
  }

  Future<void> _onResetStatus(
    ResetStatus event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.initial));
  }

  Future<Either<FailureModel, void>> _login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authenticationRepository.login(
          email: email, password: password);
      return right(response);
    } on NetworkException catch (e) {
      return left(FailureModel(message: e.message));
    }
  }
}
