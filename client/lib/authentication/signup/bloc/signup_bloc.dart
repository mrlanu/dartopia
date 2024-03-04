import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import 'package:dartopia/authentication/authentication.dart';
import 'package:models/models.dart';
import 'package:network/network.dart';

part 'signup_event.dart';

part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({
    required AuthRepo authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const SignupState()) {
    on<SignupEmailChanged>(_onEmailChanged);
    on<SignupPasswordChanged>(_onPasswordChanged);
    on<SignupConfirmPasswordChanged>(_onConfirmedPasswordChanged);
    on<SignupSubmitted>(_onSubmitted);
    on<ResetSignupStatus>(_onResetStatus);
  }

  final AuthRepo _authenticationRepository;

  void _onEmailChanged(
    SignupEmailChanged event,
    Emitter<SignupState> emit,
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
    SignupPasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([password, state.email]),
      ),
    );
  }

  void _onConfirmedPasswordChanged(
    SignupConfirmPasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    final confPassword = ConfirmedPassword.dirty(
        password: state.password.value, value: event.password);
    emit(
      state.copyWith(
        confirmedPassword: confPassword,
        isValid: Formz.validate([
          state.email,
          state.password,
          confPassword,
        ]),
      ),
    );
  }

  Future<void> _onSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      final response = await _signup(
          email: state.email.value,
          password: state.password.value,
        );
      response.fold(
            (failure) => emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: failure.message,
          ),
        ),
            (success) => emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
          ),
        ),
      );
    }
  }

  Future<Either<FailureModel, void>> _signup({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authenticationRepository.signup(
          email: email, password: password);
      return right(response);
    } on NetworkException catch (e) {
      return left(FailureModel(message: e.message));
    }
  }

  Future<void> _onResetStatus(
      ResetSignupStatus event,
      Emitter<SignupState> emit,
      ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.initial));
  }
}
