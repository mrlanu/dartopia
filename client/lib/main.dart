import 'package:authentication_repository/authentication_repository.dart';
import 'package:dartopia/authentication/bloc/auth_bloc.dart';
import 'package:dartopia/router/router.dart';
import 'package:dartopia/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AuthRepo _authRepo = AuthRepo();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => _authRepo,
      child: BlocProvider(
        create: (_) => AuthBloc()..add(CheckAuthStatus()),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        router.refresh();
        router.go('/');
      },
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        title: 'Dartopia',
        theme: dartopiaTheme,
      ),
    );
  }
}
