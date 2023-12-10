import 'package:dartopia/buildings/buildings.dart';
import 'package:dartopia/common/common.dart';
import 'package:dartopia/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:models/models.dart';

import 'rally_point.dart';

class RallyPointPage extends StatelessWidget {
  const RallyPointPage({super.key, required this.tabIndex, this.tileDetails});

  final int tabIndex;
  final TileDetails? tileDetails;

  static Route<void> route(
      {required BuildingsBloc buildingsBloc, // for getting current settlement info
      required MovementsBloc movementsBloc,
      required TroopMovementsRepository troopMovementsRepository,
      int tabIndex = 1,
      TileDetails? tileDetails}) {
    return MaterialPageRoute(builder: (context) {
      return RepositoryProvider.value(
        value: troopMovementsRepository,
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: buildingsBloc),
            BlocProvider.value(value: movementsBloc),
          ],
          child: RallyPointPage(
            tabIndex: tabIndex,
            tileDetails: tileDetails,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return RallyPointView(
      initialTabIndex: tabIndex,
      tileDetails: tileDetails,
    );
  }
}

class RallyPointView extends StatefulWidget {
  const RallyPointView(
      {super.key, required this.initialTabIndex, this.tileDetails});

  final int initialTabIndex;
  final TileDetails? tileDetails;

  @override
  State<RallyPointView> createState() => _RallyPointViewState();
}

class _RallyPointViewState extends State<RallyPointView> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: background,
        appBar: buildAppBar(),
        body: IndexedStack(index: currentIndex, children: [
          _movementsTab(),
          _sendTroopsTab(widget.tileDetails),
        ]),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _movementsTab() {
    return BlocBuilder<MovementsBloc, MovementsState>(
      builder: (context, state) {
        return state.status == MovementsStatus.initial ||
                state.status == MovementsStatus.initial
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    state.movements[MovementLocation.incoming]!.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Incoming troops (${state.movements[MovementLocation.incoming]!.length})',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        : Container(),
                    ...state.movements[MovementLocation.incoming]!
                        .map((move) => TroopDetails(
                              movement: move,
                            ))
                        .toList(),
                    state.movements[MovementLocation.outgoing]!.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Outgoing troops (${state.movements[MovementLocation.outgoing]!.length})',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        : Container(),
                    ...state.movements[MovementLocation.outgoing]!
                        .map((move) => TroopDetails(
                              movement: move,
                            ))
                        .toList(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Troops in this village and its oases (${state.movements[MovementLocation.home]!.length})',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    ...state.movements[MovementLocation.home]!
                        .map((move) => TroopDetails(
                              movement: move,
                            ))
                        .toList(),
                  ],
                ),
              );
      },
    );
  }

  Widget _sendTroopsTab(TileDetails? tileDetails) {
    return SendTroopsForm(tileDetails: tileDetails, onConfirm: () {
      setState(() {
        currentIndex = 0;
      });
    },);
  }

  Widget _buildBottomBar() {
    return Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color.fromRGBO(36, 126, 38, 1.0),
          unselectedItemColor: Colors.white38,
          selectedItemColor: Colors.white,
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: [
            _buildBottomNavigationBarItem(
                label: 'buildings', icon: const FaIcon(FontAwesomeIcons.eye)),
            _buildBottomNavigationBarItem(
                label: 'map',
                icon: const FaIcon(FontAwesomeIcons.locationCrosshairs)),
          ],
        ));
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
}
