import 'dart:async';

import 'package:dartopia/reports/reports.dart';
import 'package:dartopia/reports/view/report_page.dart';
import 'package:dartopia/statistics/statistics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../authentication/authentication.dart';
import '../building_detail/building_detail.dart';
import '../buildings/view/buildings_page_grid.dart';
import '../rally_point/rally_point.dart';
import '../settlement/settlement.dart';
import '../splash/splash.dart';
import '../world_map/world_map.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _buildingsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'buildingsNav');

/// The route configuration.
final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
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
    StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
                StatefulNavigationShell navigationShell) =>
            ScaffoldWithNavBar(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(navigatorKey: _buildingsNavigatorKey, routes: [
            GoRoute(
              path: '/buildings',
              builder: (BuildContext context, GoRouterState state) {
                return const BuildingsPageGrid();
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
              ],
            ),
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
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/world',
              builder: (BuildContext context, GoRouterState state) {
                return const WorldMapPage();
              },
            ),
          ]),
          StatefulShellBranch(observers: [
            NavigatorObserver(),
          ],
              routes: [
            GoRoute(
              path: '/statistics',
              builder: (BuildContext context, GoRouterState state) {
                return const StatisticsPage();
              },
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/reports',
              builder: (BuildContext context, GoRouterState state) {
                return const ReportsPage();
              },
              routes: [
                GoRoute(
                  path: ':reportId',
                  builder: (BuildContext context, GoRouterState state) {
                    return ReportPage(
                        reportId: state.pathParameters['reportId']!);
                  },
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/empty2',
              builder: (BuildContext context, GoRouterState state) {
                return const Scaffold();
              },
            ),
          ]),
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
    return '/buildings';
  }
  return null;
}

GoRouter get router => _router;

FutureOr<bool> onExit(BuildContext context) {
  print('ON EXIT');
  context.read<SettlementBloc>().add(const SettlementFetchRequested());
  return true;
}
