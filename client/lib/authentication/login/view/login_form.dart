import 'package:dartopia/authentication/widgets/widgets.dart';
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
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                content: Text(
                  state.errorMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                backgroundColor: Colors.redAccent.shade700,
              ),
            );
          context.read<LoginBloc>().add(const ResetStatus());
        }
      },
      child: AuthFormCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome back',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1B5E20),
                  ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Sign in to continue building your empire',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: const Color(0xFF5F6F5F),
                  ),
            ),
            SizedBox(height: 28.h),
            const _EmailInput(),
            SizedBox(height: 20.h),
            const _PasswordInput(),
            SizedBox(height: 28.h),
            const _LoginButton(),
            SizedBox(height: 20.h),
            const SignUpButton(),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return AuthTextField(
          fieldKey: const Key('loginForm_emailInput_textField'),
          label: 'Email',
          hint: 'you@example.com',
          prefixIcon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          errorText: state.email.displayError != null ? 'Invalid email' : null,
          onChanged: (email) =>
              context.read<LoginBloc>().add(LoginEmailChanged(email)),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return AuthTextField(
          fieldKey: const Key('loginForm_passwordInput_textField'),
          label: 'Password',
          hint: 'Enter your password',
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: true,
          textInputAction: TextInputAction.done,
          errorText:
              state.password.displayError != null ? 'Invalid password' : null,
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return AuthPrimaryButton(
          buttonKey: const Key('loginForm_continue_raisedButton'),
          label: 'Sign in',
          isLoading: state.status.isInProgress,
          onPressed: state.isValid && !state.status.isInProgress
              ? () => context.read<LoginBloc>().add(const LoginSubmitted())
              : null,
        );
      },
    );
  }
}
