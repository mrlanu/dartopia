import 'package:authentication_repository/authentication_repository.dart';
import 'package:dartopia/authentication/bloc/auth_bloc.dart';
import 'package:dartopia/building_detail/view/building_detail_page.dart';
import 'package:dartopia/rally_point/rally_point.dart';
import 'package:dartopia/settlement/bloc/settlement_bloc.dart';
import 'package:dartopia/settlement/repository/settlement_repository.dart';
import 'package:dartopia/settlement/view/settlement_page.dart';
import 'package:dartopia/splash/splash.dart';
import 'package:dartopia/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(
    sharedPreferences: sharedPreferences,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.sharedPreferences});

  final SharedPreferences sharedPreferences;
  final AuthRepo _authRepo = AuthRepo();
  final SettlementRepository _settlementRepository = SettlementRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => _authRepo,
        ),
        RepositoryProvider(
          create: (context) => _settlementRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc()..add(CheckAuthStatus()),
          ),
          BlocProvider(
            create: (context) =>
                SettlementBloc(settlementRepository: _settlementRepository),
          ),
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        _router.refresh();
        _router.go('/');
      },
      child: MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        title: 'Dartopia',
        theme: dartopiaTheme,
      ),
    );
  }

  /// The route configuration.
  late final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        redirect: (_, __) => '/settlement',
      ),
      GoRoute(
        path: '/splash',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashPage();
        },
      ),
      GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
          routes: [
            GoRoute(
              path: 'signup',
              builder: (BuildContext context, GoRouterState state) {
                return const SignupPage();
              },
            ),
          ]),
      GoRoute(
          path: '/settlement',
          builder: (BuildContext context, GoRouterState state) {
            return const SettlementPage();
          },
          routes: [
            GoRoute(
              path: 'details',
              builder: (context, state) {
                final buildingRecord = state.extra as List<int>;
                context
                    .read<SettlementBloc>()
                    .add(const SettlementFetchRequested());
                return BuildingDetailPage(buildingRecord: buildingRecord);
              },
              onExit: (context) async {
                context
                    .read<SettlementBloc>()
                    .add(const SettlementFetchRequested());
                return true;
              },
            ),
          ]),
      GoRoute(
        path: '/rally_point/:tabId',
        builder: (BuildContext context, GoRouterState state) {
          final x = state.uri.queryParameters['x'] ?? 0.toString();
          final y = state.uri.queryParameters['y'] ?? 0.toString();
          final coordinates = [int.parse(x), int.parse(y)];
          return RallyPointPage(
              targetCoordinates: coordinates,
              tabIndex: int.parse(state.pathParameters['tabId']!));
        },
      ),
    ],
    redirect: _guard,
    debugLogDiagnostics: true,
  );

  Future<String?> _guard(BuildContext context, GoRouterState state) async {
    final bool signedIn = context.read<AuthBloc>().state is AuthenticatedState;
    if (context.read<AuthBloc>().state is UnknownState) {
      return '/splash';
    }
    final bool signingIn =
        ['/login', '/login/signup', '/splash'].contains(state.matchedLocation);
    if (!signedIn && !signingIn) {
      return '/login';
    } else if (signedIn && signingIn) {
      return '/settlement';
    }
    return null;
  }
}
