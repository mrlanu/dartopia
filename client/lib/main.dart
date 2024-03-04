import 'package:authentication_repository/authentication_repository.dart';
import 'package:dartopia/authentication/bloc/auth_bloc.dart';
import 'package:dartopia/settlement/view/settlement_page.dart';
import 'package:dartopia/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication/authentication.dart';
import 'splash/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(
    sharedPreferences: sharedPreferences,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthRepo _authRepo;

  @override
  void initState() {
    super.initState();
    _authRepo = AuthRepo();
  }

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

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Dartopia',
      theme: dartopiaTheme,
      builder: (context, child) {
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            switch (state) {
              case AuthenticatedState():
                _navigator.pushAndRemoveUntil<void>(
                  SettlementPage.route(token: 'state.token'),
                  (route) => false,
                );
              case UnauthenticatedState():
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false,
                );
              case UnknownState():
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
