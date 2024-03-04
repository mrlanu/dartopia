import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../signup.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text(
                  'Account has been created',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
                backgroundColor: Colors.green,
              ),
            );
          Navigator.of(context).pop();
        }
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
                backgroundColor: Colors.redAccent,
              ),
            );
          context.read<SignupBloc>().add(const ResetSignupStatus());
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EmailInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _PasswordInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _ConfirmPasswordInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _SignupButton(),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('signupForm_emILInput_textField'),
          onChanged: (email) =>
              context.read<SignupBloc>().add(SignupEmailChanged(email)),
          decoration: InputDecoration(
            labelText: 'email',
            errorText:
                state.email.displayError != null ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signupForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<SignupBloc>().add(SignupPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password',
            errorText:
                state.password.displayError != null ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) =>
      previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return TextField(
          key: const Key('signupForm_confirmPasswordInput_textField'),
          onChanged: (password) =>
              context.read<SignupBloc>().add(SignupConfirmPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'confirm password',
            errorText: state.confirmedPassword.displayError != null
                ? 'passwords do not match'
                : null,
          ),
        );
      },
    );
  }
}

class _SignupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: ElevatedButton(
                  key: const Key('signupForm_continue_raisedButton'),
                  onPressed: state.isValid
                      ? () {
                          context.read<SignupBloc>().add(const SignupSubmitted());
                        }
                      : null,
                  child: const Text('Signup', style: TextStyle(fontSize: 30),),
                ),
            );
      },
    );
  }
}
