import 'package:dartopia/village/cubit/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            backgroundColor: Color.fromRGBO(36, 126, 38, 1.0),
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
              _buildBottomNavigationBarItem(
                  label: 'reports',
                  icon: const FaIcon(FontAwesomeIcons.book)),
              _buildBottomNavigationBarItem(
                  label: 'mail',
                  icon: const FaIcon(FontAwesomeIcons.envelopeOpenText)),
            ],
          );
        },
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({required String label,
    required Widget icon,}) {
    return BottomNavigationBarItem(
      label: label,
      icon: icon,
    );
  }
}
