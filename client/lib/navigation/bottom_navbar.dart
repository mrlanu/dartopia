import 'package:dartopia/messages/messages.dart';
import 'package:dartopia/settlement/bloc/settlement_bloc.dart';
import 'package:dartopia/statistics/cubit/statistics_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../consts/colors.dart';
import '../reports/bloc/reports_bloc.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: DartopiaColors.primary,
          unselectedItemColor: DartopiaColors.white38,
          selectedItemColor: DartopiaColors.onPrimary,
          currentIndex: widget.navigationShell.currentIndex,
          onTap: (index) => _onTap(context, index),
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          //selectedItemColor: bottomNavBarSelectedItem,
          //unselectedItemColor: bottomNavBarItem,
          type: BottomNavigationBarType.fixed,
          iconSize: 22.sp,
          items: [
            BottomNavigationBarItem(
                label: 'buildings',
                icon: FaIcon(FontAwesomeIcons.houseChimney, size: 22.sp)),
            BottomNavigationBarItem(
                label: 'map',
                icon: FaIcon(FontAwesomeIcons.mapLocationDot, size: 22.sp)),
            BottomNavigationBarItem(
                label: 'charts',
                icon: FaIcon(FontAwesomeIcons.chartLine, size: 22.sp)),
            _buildReportsBarItem(context),
            _buildMessagesBarItem(context),
          ],
        ));
  }

  void _onTap(BuildContext context, int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
    switch (index) {
      case 0:
        context.read<SettlementBloc>().add(const SettlementFetchRequested());
        context.read<MessagesCubit>().countNewMessages();
        break;
      case 1:
        break;
      case 2:
        context.read<StatisticsCubit>().fetchStatistics();
        break;
      case 3:
        context.read<ReportsBloc>().add(const ListOfBriefsRequested());
        break;
      case 4:
        context.read<MessagesCubit>().fetchMessages();
        break;
    }
  }

  BottomNavigationBarItem _buildReportsBarItem(BuildContext context) {
    return BottomNavigationBarItem(
        label: 'reports',
        icon: BlocBuilder<ReportsBloc, ReportsState>(
          builder: (context, state) {
            return state.amount == 0
                ? FaIcon(FontAwesomeIcons.book, size: 22.sp)
                : Badge(
                    label: Text('${state.amount}',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: Colors.white)),
                    child: FaIcon(FontAwesomeIcons.book, size: 22.sp),
                  );
          },
        ));
  }

  BottomNavigationBarItem _buildMessagesBarItem(BuildContext context) {
    return BottomNavigationBarItem(
        label: 'messages',
        icon: BlocBuilder<MessagesCubit, MessagesState>(
          builder: (context, state) {
            return state.newMessagesAmount == 0
                ? FaIcon(FontAwesomeIcons.envelopeOpenText, size: 22.sp)
                : Badge(
                    label: Text('${state.newMessagesAmount}',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: Colors.white)),
                    child:
                        FaIcon(FontAwesomeIcons.envelopeOpenText, size: 22.sp),
                  );
          },
        ));
  }
}
