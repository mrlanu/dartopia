import 'package:dartopia/authentication/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              SnackBar(
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                content: Text(
                  'Account created successfully',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                backgroundColor: const Color(0xFF2E7D32),
              ),
            );
          Navigator.of(context).pop();
        }
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
          context.read<SignupBloc>().add(const ResetSignupStatus());
        }
      },
      child: AuthFormCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create account',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1B5E20),
                  ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Join Dartopia and start your adventure',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: const Color(0xFF5F6F5F),
                  ),
            ),
            SizedBox(height: 24.h),
            const _EmailInput(),
            SizedBox(height: 16.h),
            const _PasswordInput(),
            SizedBox(height: 16.h),
            const _ConfirmPasswordInput(),
            SizedBox(height: 24.h),
            const _SignupButton(),
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
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return AuthTextField(
          fieldKey: const Key('signupForm_emILInput_textField'),
          label: 'Email',
          hint: 'you@example.com',
          prefixIcon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          errorText: state.email.displayError != null ? 'Invalid email' : null,
          onChanged: (email) =>
              context.read<SignupBloc>().add(SignupEmailChanged(email)),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return AuthTextField(
          fieldKey: const Key('signupForm_passwordInput_textField'),
          label: 'Password',
          hint: 'At least 6 characters',
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: true,
          textInputAction: TextInputAction.next,
          errorText:
              state.password.displayError != null ? 'Invalid password' : null,
          onChanged: (password) =>
              context.read<SignupBloc>().add(SignupPasswordChanged(password)),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  const _ConfirmPasswordInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return AuthTextField(
          fieldKey: const Key('signupForm_confirmPasswordInput_textField'),
          label: 'Confirm password',
          hint: 'Repeat your password',
          prefixIcon: Icons.lock_person_outlined,
          obscureText: true,
          textInputAction: TextInputAction.done,
          errorText: state.confirmedPassword.displayError != null
              ? 'Passwords do not match'
              : null,
          onChanged: (password) => context
              .read<SignupBloc>()
              .add(SignupConfirmPasswordChanged(password)),
        );
      },
    );
  }
}

class _SignupButton extends StatelessWidget {
  const _SignupButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return AuthPrimaryButton(
          buttonKey: const Key('signupForm_continue_raisedButton'),
          label: 'Create account',
          isLoading: state.status.isInProgress,
          onPressed: state.isValid && !state.status.isInProgress
              ? () => context.read<SignupBloc>().add(const SignupSubmitted())
              : null,
        );
      },
    );
  }
}
