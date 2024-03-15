import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../consts/colors.dart';
import '../reports/bloc/reports_bloc.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

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
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => _onTap(context, index),
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          //selectedItemColor: bottomNavBarSelectedItem,
          //unselectedItemColor: bottomNavBarItem,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
                label: 'buildings',
                icon: FaIcon(FontAwesomeIcons.houseChimney)),
            const BottomNavigationBarItem(
                label: 'map',
                icon: FaIcon(FontAwesomeIcons.mapLocationDot)),
            const BottomNavigationBarItem(
                label: 'charts',
                icon: FaIcon(FontAwesomeIcons.chartLine)),
            _buildReportsBarItem(context),
            const BottomNavigationBarItem(
                label: 'mail',
                icon: FaIcon(FontAwesomeIcons.envelopeOpenText)),
          ],
        ));
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  BottomNavigationBarItem _buildReportsBarItem(BuildContext context) {
    return BottomNavigationBarItem(
        label: 'reports',
        icon: BlocBuilder<ReportsBloc, ReportsState>(
          builder: (context, state) {
            return state.amount == 0
                ? const FaIcon(FontAwesomeIcons.book)
                : Badge(
              label: Text('${state.amount}',
                  style:
                  const TextStyle(fontSize: 12, color: Colors.white)),
              child: const FaIcon(FontAwesomeIcons.book),
            );
          },
        ));
  }
}
