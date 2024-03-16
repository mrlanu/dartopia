import 'package:dartopia/building_detail/building_detail.dart';
import 'package:dartopia/buildings/buildings.dart';
import 'package:dartopia/rally_point/rally_point.dart';
import 'package:dartopia/splash/splash.dart';
import 'package:dartopia/world_map/view/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../authentication/authentication.dart';
import '../reports/reports.dart';
import '../reports/view/report_page.dart';
import '../settlement/settlement.dart';

part 'router.g.dart';

GoRouter get router => _router;

final GlobalKey<NavigatorState> _sectionANavigatorKey =
GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

final GoRouter _router = GoRouter(
  routes: $appRoutes,
  initialLocation: '/buildings',
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

@TypedGoRoute<RootScreen>(path: '/')
@immutable
class RootScreen extends GoRouteData {
  @override
  String? redirect(BuildContext context, GoRouterState state) =>
      SplashScreenRoute().location;
}

@TypedGoRoute<SplashScreenRoute>(path: '/splash')
@immutable
class SplashScreenRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) => const SplashPage();
}

@TypedGoRoute<LoginRoute>(path: '/login', routes: [
  TypedGoRoute<SignupRoute>(path: 'signup'),
])
@immutable
class LoginRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginPage();
}

class SignupRoute extends GoRouteData {
  const SignupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SignupPage();
  }
}

@TypedStatefulShellRoute<MainShellRoute>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<BranchBuildings>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<BuildingsRoute>(path: '/buildings', routes: [
          TypedGoRoute<BuildingDetailsRoute>(path: 'details'),
        ]),
        TypedGoRoute<RallyPointRoute>(path: '/rally_point/:tabId'),
      ],
    ),
    TypedStatefulShellBranch<BranchWorld>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<WorldRoute>(path: '/world'),
      ],
    ),
    TypedStatefulShellBranch<BranchStatistics>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<StatisticsRoute>(path: '/statistics'),
      ],
    ),
    TypedStatefulShellBranch<BranchReports>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ReportsRoute>(
            path: '/reports',
            routes: [TypedGoRoute<ReportDetailsRoute>(path: ':reportId')]),
      ],
    ),
    TypedStatefulShellBranch<BranchMessages>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<MessagesRoute>(path: '/messages'),
      ],
    ),
  ],
)
class MainShellRoute extends StatefulShellRouteData {
  const MainShellRoute();

  @override
  Widget builder(
      BuildContext context,
      GoRouterState state,
      StatefulNavigationShell navigationShell,
      ) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<SettlementRepository>(
            create: (context) => SettlementRepositoryImpl(),
          ),
          RepositoryProvider<ReportsRepository>(
            create: (context) => ReportsRepositoryImpl(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SettlementBloc(
                  settlementRepository: context.read<SettlementRepository>())
                ..add(const ListOfSettlementsRequested()),
            ),
            BlocProvider(
              create: (context) => ReportsBloc(
                  reportsRepository: context.read<ReportsRepository>()),
            ),
          ],
          child: ScaffoldWithNavBar(navigationShell: navigationShell),
        ));
  }

  static const String $restorationScopeId = 'restorationScopeId';
}

class BranchBuildings extends StatefulShellBranchData {
  const BranchBuildings();
}

class BranchWorld extends StatefulShellBranchData {
  static final GlobalKey<NavigatorState> $navigatorKey = _sectionANavigatorKey;
  static const String $restorationScopeId = 'restorationScopeId';

  const BranchWorld();
}

class BranchStatistics extends StatefulShellBranchData {
  const BranchStatistics();
}

class BranchReports extends StatefulShellBranchData {
  const BranchReports();
}

class BranchMessages extends StatefulShellBranchData {
  const BranchMessages();
}

class BuildingsRoute extends GoRouteData {
  const BuildingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const BuildingsPageGrid();
  }
}

class BuildingDetailsRoute extends GoRouteData {
  const BuildingDetailsRoute({required this.$extra});

  final List<int> $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BuildingDetailPage(
      buildingRecord: $extra,
    );
  }
}

class RallyPointRoute extends GoRouteData {
  const RallyPointRoute({required this.tabId, this.x = '0', this.y = '0'});

  final String tabId;
  final String x;
  final String y;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return RallyPointPage(
      targetCoordinates: [int.parse(x), int.parse(y)],
      tabIndex: int.parse(tabId),
    );
  }
}

class WorldRoute extends GoRouteData {
  const WorldRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const WorldMapPage();
  }
}

class StatisticsRoute extends GoRouteData {
  const StatisticsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Scaffold(
      body: Center(
        child: Text('Statistics'),
      ),
    );
  }
}

class ReportsRoute extends GoRouteData {
  const ReportsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ReportsPage();
  }
}

class ReportDetailsRoute extends GoRouteData {
  const ReportDetailsRoute({required this.reportId});

  final String reportId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ReportPage(
      reportId: reportId,
    );
  }
}

class MessagesRoute extends GoRouteData {
  const MessagesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Scaffold(
      body: Center(
        child: Text('Messages'),
      ),
    );
  }
}
