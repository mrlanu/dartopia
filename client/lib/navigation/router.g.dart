// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $rootScreen,
      $splashScreenRoute,
      $loginRoute,
      $mainShellRoute,
    ];

RouteBase get $rootScreen => GoRouteData.$route(
      path: '/',
      factory: $RootScreenExtension._fromState,
    );

extension $RootScreenExtension on RootScreen {
  static RootScreen _fromState(GoRouterState state) => RootScreen();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $splashScreenRoute => GoRouteData.$route(
      path: '/splash',
      factory: $SplashScreenRouteExtension._fromState,
    );

extension $SplashScreenRouteExtension on SplashScreenRoute {
  static SplashScreenRoute _fromState(GoRouterState state) =>
      SplashScreenRoute();

  String get location => GoRouteData.$location(
        '/splash',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginRoute => GoRouteData.$route(
      path: '/login',
      factory: $LoginRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'signup',
          factory: $SignupRouteExtension._fromState,
        ),
      ],
    );

extension $LoginRouteExtension on LoginRoute {
  static LoginRoute _fromState(GoRouterState state) => LoginRoute();

  String get location => GoRouteData.$location(
        '/login',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SignupRouteExtension on SignupRoute {
  static SignupRoute _fromState(GoRouterState state) => const SignupRoute();

  String get location => GoRouteData.$location(
        '/login/signup',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mainShellRoute => StatefulShellRouteData.$route(
      restorationScopeId: MainShellRoute.$restorationScopeId,
      factory: $MainShellRouteExtension._fromState,
      branches: [
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/buildings',
              factory: $BuildingsRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'details',
                  factory: $BuildingDetailsRouteExtension._fromState,
                ),
              ],
            ),
            GoRouteData.$route(
              path: '/rally_point/:tabId',
              factory: $RallyPointRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          navigatorKey: BranchWorld.$navigatorKey,
          restorationScopeId: BranchWorld.$restorationScopeId,
          routes: [
            GoRouteData.$route(
              path: '/world',
              factory: $WorldRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/statistics',
              factory: $StatisticsRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/reports',
              factory: $ReportsRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: ':reportId',
                  factory: $ReportDetailsRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/messages',
              factory: $MessagesRouteExtension._fromState,
            ),
          ],
        ),
      ],
    );

extension $MainShellRouteExtension on MainShellRoute {
  static MainShellRoute _fromState(GoRouterState state) =>
      const MainShellRoute();
}

extension $BuildingsRouteExtension on BuildingsRoute {
  static BuildingsRoute _fromState(GoRouterState state) =>
      const BuildingsRoute();

  String get location => GoRouteData.$location(
        '/buildings',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $BuildingDetailsRouteExtension on BuildingDetailsRoute {
  static BuildingDetailsRoute _fromState(GoRouterState state) =>
      BuildingDetailsRoute(
        $extra: state.extra as List<int>,
      );

  String get location => GoRouteData.$location(
        '/buildings/details',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $RallyPointRouteExtension on RallyPointRoute {
  static RallyPointRoute _fromState(GoRouterState state) => RallyPointRoute(
        tabId: state.pathParameters['tabId']!,
        x: state.uri.queryParameters['x'] ?? '0',
        y: state.uri.queryParameters['y'] ?? '0',
      );

  String get location => GoRouteData.$location(
        '/rally_point/${Uri.encodeComponent(tabId)}',
        queryParams: {
          if (x != '0') 'x': x,
          if (y != '0') 'y': y,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $WorldRouteExtension on WorldRoute {
  static WorldRoute _fromState(GoRouterState state) => const WorldRoute();

  String get location => GoRouteData.$location(
        '/world',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $StatisticsRouteExtension on StatisticsRoute {
  static StatisticsRoute _fromState(GoRouterState state) =>
      const StatisticsRoute();

  String get location => GoRouteData.$location(
        '/statistics',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ReportsRouteExtension on ReportsRoute {
  static ReportsRoute _fromState(GoRouterState state) => const ReportsRoute();

  String get location => GoRouteData.$location(
        '/reports',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ReportDetailsRouteExtension on ReportDetailsRoute {
  static ReportDetailsRoute _fromState(GoRouterState state) =>
      ReportDetailsRoute(
        reportId: state.pathParameters['reportId']!,
      );

  String get location => GoRouteData.$location(
        '/reports/${Uri.encodeComponent(reportId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MessagesRouteExtension on MessagesRoute {
  static MessagesRoute _fromState(GoRouterState state) => const MessagesRoute();

  String get location => GoRouteData.$location(
        '/messages',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
