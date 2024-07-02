import 'package:dartopia/authentication/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDrawer extends StatefulWidget {
  final TabController? tabController;

  const MainDrawer({super.key, this.tabController});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromRGBO(21, 56, 2, 1.0),
                Color.fromRGBO(26, 89, 5, 1.0),
              ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
              child: FutureBuilder(
                future: SharedPreferences.getInstance().then(
                  (value) => value.getString('name'),
                ),
                builder: (_, snapshot) {
                  return snapshot.connectionState == ConnectionState.done
                      ? Center(
                          child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              child: Text(
                                'Dartopia for ${snapshot.data}',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 25),
                              )))
                      : const Center(child: CircularProgressIndicator());
                },
              )),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const FaIcon(FontAwesomeIcons.rightFromBracket,
                          color: Colors.green),
                      title: Text('Log out',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.black)),
                      onTap: () {
                        context.read<AuthBloc>().add(AuthLogoutRequested());
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
