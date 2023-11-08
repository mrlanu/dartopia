import 'package:dartopia/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum NavBarTab {
  buildings,
  map,
  charts,
  reports,
  mail,
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key,});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  late NavBarTab _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = NavBarTab.buildings;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        //backgroundColor: bottomNavBarBackground,
        currentIndex: _selectedTab.index,
        onTap: (value) {
          setState(() {
            _selectedTab = NavBarTab.values[value];
          });
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
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      {required String label,
        required Widget icon,}) {
    return BottomNavigationBarItem(
      label: label,
      icon: icon,
    );
  }
}
