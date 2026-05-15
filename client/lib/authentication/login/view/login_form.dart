import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';

import '../login.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
                backgroundColor: Colors.redAccent,
              ),
            );
          context.read<LoginBloc>().add(const ResetStatus());
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EmailInput(),
            Padding(padding: EdgeInsets.all(12.w)),
            _PasswordInput(),
            Padding(padding: EdgeInsets.all(12.w)),
            _LoginButton(),
            Padding(padding: EdgeInsets.all(12.w)),
            const SignUpButton()
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) =>
              context.read<LoginBloc>().add(LoginEmailChanged(email)),
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
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
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

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : Padding(
                padding: EdgeInsets.only(top: 28.h),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    key: const Key('loginForm_continue_raisedButton'),
                    onPressed: state.isValid
                        ? () {
                            context
                                .read<LoginBloc>()
                                .add(const LoginSubmitted());
                          }
                        : null,
                    child: Text(
                      'Login',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
              );
      },
    );
  }
}
