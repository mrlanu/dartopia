import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../reports/bloc/reports_bloc.dart';
import '../settlement/settlement.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return BottomNavigationBar(
            backgroundColor: const Color.fromRGBO(36, 126, 38, 1.0),
            unselectedItemColor: Colors.white38,
            selectedItemColor: Colors.white,
            currentIndex: state.tab.index,
            onTap: (value) {
              context.read<NavigationCubit>().setTab(NavTab.values[value]);
            },
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            //selectedItemColor: bottomNavBarSelectedItem,
            //unselectedItemColor: bottomNavBarItem,
            type: BottomNavigationBarType.fixed,
            items: [
              _buildBottomNavigationBarItem(
                  label: 'buildings',
                  icon: const FaIcon(FontAwesomeIcons.houseChimney)),
              _buildBottomNavigationBarItem(
                  label: 'map',
                  icon: const FaIcon(FontAwesomeIcons.mapLocationDot)),
              _buildBottomNavigationBarItem(
                  label: 'charts',
                  icon: const FaIcon(FontAwesomeIcons.chartLine)),
              _buildReportsBarItem(context),
              _buildBottomNavigationBarItem(
                  label: 'mail',
                  icon: const FaIcon(FontAwesomeIcons.envelopeOpenText)),
            ],
          );
        },
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required String label,
    required Widget icon,
  }) {
    return BottomNavigationBarItem(
      label: label,
      icon: icon,
    );
  }

  BottomNavigationBarItem _buildReportsBarItem(BuildContext context) {
    return BottomNavigationBarItem(
        label: 'reports',
        icon: BlocBuilder<ReportsBloc, ReportsState>(
          builder: (context, state) {
            return state.amount == 0
                ? const FaIcon(FontAwesomeIcons.book)
                : SizedBox(
                    width: 30,
                    child: Stack(
                      children: [
                        const FaIcon(FontAwesomeIcons.book),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              // Adjust the border radius
                              color: Colors.redAccent,
                            ),
                            child: Text('${state.amount}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ));
  }
}
