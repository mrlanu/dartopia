import 'package:dartopia/common/common.dart';
import 'package:dartopia/consts/calors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:models/models.dart';

import '../settlement/settlement.dart';
import 'rally_point.dart';

class RallyPointPage extends StatelessWidget {
  const RallyPointPage(
      {super.key, required this.tabIndex, this.targetCoordinates});

  final int tabIndex;
  final List<int>? targetCoordinates;

  static Route<void> route(
      {required SettlementBloc settlementBloc, // for getting current settlement info
      int tabIndex = 0,
      List<int>? targetCoordinates}) {
    return MaterialPageRoute(builder: (context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: settlementBloc),
        ],
        child: RallyPointPage(
          tabIndex: tabIndex,
          targetCoordinates: targetCoordinates,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return RallyPointView(
          initialTabIndex: tabIndex,
          targetCoordinates: targetCoordinates,
        );
  }
}

class RallyPointView extends StatefulWidget {
  const RallyPointView(
      {super.key, required this.initialTabIndex, this.targetCoordinates});

  final int initialTabIndex;
  final List<int>? targetCoordinates;

  @override
  State<RallyPointView> createState() => _RallyPointViewState();
}

class _RallyPointViewState extends State<RallyPointView> {
  late int currentIndex;
  late final TroopMovementsRepository _troopMovementsRepository;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialTabIndex;
    //final token = context.read<AuthBloc>().state.token;
    _troopMovementsRepository = TroopMovementsRepositoryImpl();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
  create: (context) => _troopMovementsRepository,
    child: SafeArea(
      child: Scaffold(
        backgroundColor: DartopiaColors.background,
        appBar: buildAppBar(),
        body: IndexedStack(index: currentIndex, children: [
          _movementsTab(),
          _sendTroopsTab(widget.targetCoordinates),
        ]),
        bottomNavigationBar: _buildBottomBar(),
      ),
    ),
);
  }

  Widget _movementsTab() {
    return BlocBuilder<SettlementBloc, SettlementState>(
      builder: (context, state) {
        return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    state.movementsByLocationMap[MovementLocation.incoming]!.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Incoming troops (${state.movementsByLocationMap[MovementLocation.incoming]!.length})',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        : Container(),
                    ...state.movementsByLocationMap[MovementLocation.incoming]!
                        .map((move) => TroopDetailsTable(
                              movement: move,
                            ))
                        .toList(),
                    state.movementsByLocationMap[MovementLocation.outgoing]!.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Outgoing troops (${state.movementsByLocationMap[MovementLocation.outgoing]!.length})',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        : Container(),
                    ...state.movementsByLocationMap[MovementLocation.outgoing]!
                        .map((move) => TroopDetailsTable(
                              movement: move,
                            ))
                        .toList(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Troops in this village and its oases (${state.movementsByLocationMap[MovementLocation.home]!.length})',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    ...state.movementsByLocationMap[MovementLocation.home]!
                        .map((move) => TroopDetailsTable(
                              movement: move,
                            ))
                        .toList(),
                    state.movementsByLocationMap[MovementLocation.away]!.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Armies in other places (${state.movementsByLocationMap[MovementLocation.away]!.length})',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        : Container(),
                    ...state.movementsByLocationMap[MovementLocation.away]!
                        .map((move) => TroopDetailsTable(
                              movement: move,
                            ))
                        .toList(),
                  ],
                ),
              );
      },
    );
  }

  Widget _sendTroopsTab(List<int>? targetCoordinates) {
    return SendTroopsForm(
      targetCoordinates: targetCoordinates,
      onConfirm: () {
        setState(() {
          currentIndex = 0;
        });
      },
    );
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
