import 'package:authentication_repository/authentication_repository.dart';
import 'package:dartopia/authentication/bloc/auth_bloc.dart';
import 'package:dartopia/navigation/router.dart';
import 'package:dartopia/reports/bloc/reports_bloc.dart';
import 'package:dartopia/reports/repository/reports_repository.dart';
import 'package:dartopia/settlement/bloc/settlement_bloc.dart';
import 'package:dartopia/settlement/repository/settlement_repository.dart';
import 'package:dartopia/statistics/cubit/statistics_cubit.dart';
import 'package:dartopia/statistics/statistics_repository.dart';
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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => _authRepo,
        ),
        RepositoryProvider<SettlementRepository>(
          create: (context) => SettlementRepositoryImpl(),
        ),
        RepositoryProvider<ReportsRepository>(
          create: (context) => ReportsRepositoryImpl(),
        ),
        RepositoryProvider<StatisticsRepository>(
          create: (context) => StatisticsRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc()..add(CheckAuthStatus()),
          ),
          BlocProvider(
            create: (context) => SettlementBloc(
                settlementRepository: context.read<SettlementRepository>()),
          ),
          BlocProvider(
              create: (context) => ReportsBloc(
                    reportsRepository: context.read<ReportsRepository>(),
                  )),
          BlocProvider(
            create: (context) => StatisticsCubit(
                statisticsRepository: context.read<StatisticsRepository>()),
          ),
        ],
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
