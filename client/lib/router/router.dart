import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../authentication/bloc/auth_bloc.dart';
import '../authentication/login/view/login_page.dart';
import '../authentication/signup/view/signup_page.dart';
import '../building_detail/view/building_detail_page.dart';
import '../rally_point/rally_point_page.dart';
import '../settlement/bloc/settlement_bloc.dart';
import '../settlement/repository/settlement_repository.dart';
import '../settlement/view/settlement_page.dart';
import '../splash/view/splash_page.dart';

/// The route configuration.
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      redirect: (_, __) => '/login',
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
    ShellRoute(
        builder: (_, __, child) => BlocProvider(
            create: (context) =>
                SettlementBloc(settlementRepository: SettlementRepositoryImpl())
                  ..add(const ListOfSettlementsRequested()),
            child: child),
        routes: [
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
        ]),
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

GoRouter get router => _router;
