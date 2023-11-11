import 'package:dartopia/buildings/view/building_widgets/building_widgets_map.dart';
import 'package:dartopia/storage_bar/view/storage_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:models/models.dart';

import '../../consts/consts.dart';
import '../buildings.dart';

class BuildingsPage extends StatelessWidget {
  const BuildingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuildingsBloc, BuildingsState>(
        builder: (context, state) {
      return state.status == VillageStatus.loading
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : BuildingsView(
              startBuildingIndex: state.buildingIndex,
              settlement: state.settlement!,
              buildingRecords: state.buildingRecords,
            );
    });
  }
}

class BuildingsView extends StatefulWidget {
  const BuildingsView(
      {super.key,
      this.startBuildingIndex = 0,
      required this.settlement,
      required this.buildingRecords});

  final List<List<int>> buildingRecords;
  final Settlement settlement;
  final int startBuildingIndex;

  @override
  State<BuildingsView> createState() => _BuildingsViewState();
}

class _BuildingsViewState extends State<BuildingsView>
    with TickerProviderStateMixin {
  late int currentBuildingIndex;
  late PageController buildingsPageController;
  AnimationController? titleController;
  double viewPortFractionTopping = 0.3;
  late double? pageOffsetBuilding;

  @override
  void initState() {
    currentBuildingIndex = widget.startBuildingIndex;
    pageOffsetBuilding = widget.startBuildingIndex.toDouble();
    buildingsPageController = PageController(
        initialPage: widget.startBuildingIndex,
        viewportFraction: viewPortFractionTopping)
      ..addListener(() {
        setState(() {
          pageOffsetBuilding = buildingsPageController.page;
        });
      });
    titleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..forward();
    super.initState();
  }

  late final Animation<Offset> _offsetTitle = Tween<Offset>(
          begin: const Offset(0.0, 0.5), end: const Offset(0, 0))
      .animate(CurvedAnimation(parent: titleController!, curve: Curves.linear));

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final specification =
        buildingSpecefication[widget.buildingRecords[currentBuildingIndex][1]]!;
    return Scaffold(
      backgroundColor: background,
      body: Column(
        children: [
          const SizedBox(
            height: 3,
          ),
          StorageBar(
            settlement: widget.settlement,
          ),
          const SizedBox(
            height: 3,
          ),
          Expanded(
            child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: buildingWidgetsMap[specification.id]!(
                    currentBuildingIndex +
                        offsetForFieldsCarousel)), //12 is a offset
          ),
          const Divider(),
          SizedBox(
            height: 140,
            width: size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  controller: buildingsPageController,
                  onPageChanged: (value) {
                    setState(() {
                      currentBuildingIndex =
                          value % widget.buildingRecords.length;
                      titleController!.forward(from: 0);
                    });
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: (pageOffsetBuilding! - index).abs() * 40),
                      child: BuildingPicture(
                          key: UniqueKey(),
                          buildingRecord: widget.buildingRecords[
                              index % widget.buildingRecords.length]),
                    );
                  },
                ),
                Positioned(
                  bottom: 10,
                  child: ClipPath(
                    clipper: CustomClip(),
                    child: Container(
                      height: 30,
                      width: 350,
                      color: black.withOpacity(0.35),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Building building) => AppBar(
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.gear))
        ],
        //backgroundColor: transparent,
        elevation: 0,
        /*title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          transitionBuilder: (child, animation) {
            return SlideTransition(position: _offsetTitle, child: child);
          },
          child: Column(
            children: [
              Text(
                building.name,
                style: font.copyWith(
                    fontSize: 24, fontWeight: FontWeight.bold, color: black),
              ),
              Text(
                'level: ${widget.buildingRecords[currentBuildingIndex][2]}',
                overflow: TextOverflow.clip,
                style:
                    font.copyWith(fontSize: 14, color: black.withOpacity(0.8)),
              )
            ],
          ),
        ),*/
      );
}

class CustomClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.quadraticBezierTo(size.width / 2, size.height * 2, size.width, 0);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
        size.width / 2, 2 * size.height - (size.width / 40), 0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
