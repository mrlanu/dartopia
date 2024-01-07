import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFC0D9B6),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: BlocProvider(
            create: (context) {
              return LoginBloc(
                authenticationRepository:
                RepositoryProvider.of<AuthenticationRepository>(context),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(40.0),
              child: LoginForm(),
            ),
          ),
        ),
      ),
    );
  }
}

