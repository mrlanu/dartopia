import 'package:authentication_repository/authentication_repository.dart';
import 'package:dartopia/authentication/bloc/auth_bloc.dart';
import 'package:dartopia/messages/messages.dart';
import 'package:dartopia/navigation/router.dart';
import 'package:dartopia/periodic_update/cubit/periodic_update_cubit.dart';
import 'package:dartopia/reports/bloc/reports_bloc.dart';
import 'package:dartopia/reports/repository/reports_repository.dart';
import 'package:dartopia/settings/cubit/settings_cubit.dart';
import 'package:dartopia/settings/settings_repository.dart';
import 'package:dartopia/settlement/bloc/settlement_bloc.dart';
import 'package:dartopia/settlement/repository/settlement_repository.dart';
import 'package:dartopia/statistics/cubit/statistics_cubit.dart';
import 'package:dartopia/statistics/statistics_repository.dart';
import 'package:dartopia/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepo(),
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
        RepositoryProvider<MessagesRepository>(
          create: (context) => MessagesRepositoryImpl(),
        ),
        RepositoryProvider<SettingsRepository>(
          create: (context) => SettingsRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (context) => SettingsCubit(
              context.read<SettingsRepository>(),
            )..load(),
          ),
          BlocProvider(
            lazy: false,
            create: (context) => AuthBloc(
                authenticationRepository: context.read<AuthRepo>(),)
              ..add(AuthenticationSubscriptionRequested()),
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
          BlocProvider(
            create: (context) => MessagesCubit(
                messagesRepository: context.read<MessagesRepository>()),
          ),
          BlocProvider(
            create: (context) => PeriodicUpdateCubit(
                reportsRepository: context.read<ReportsRepository>(),
                settlementRepository: context.read<SettlementRepository>(),
                messagesRepository: context.read<MessagesRepository>()),
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
    return SafeArea(
      child: MaterialApp.router(
        routerConfig: router(authBloc: context.read<AuthBloc>()),
        debugShowCheckedModeBanner: false,
        title: 'Dartopia',
        theme: dartopiaTheme,
      ),
    );
  }
}
