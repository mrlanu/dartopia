import 'package:authentication_repository/authentication_repository.dart';
import 'package:dartopia/authentication/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../signup.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SignupPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupBloc(
        authenticationRepository: context.read<AuthRepo>(),
      ),
      child: const AuthPageShell(
        showBackButton: true,
        child: SignupForm(),
      ),
    );
  }
}
