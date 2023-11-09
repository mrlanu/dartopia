import 'package:dartopia/bottom_navbar/bottom_navbar.dart';
import 'package:dartopia/buildings/view/building_widgets/building_widgets_map.dart';
import 'package:dartopia/buildings/view/widgets/building_picture.dart';
import 'package:dartopia/storage_bar/view/storage_bar.dart';
import 'package:dartopia/village/repository/village_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:models/models.dart';

import '../../consts/consts.dart';
import '../../village/bloc/village_bloc.dart';

class BuildingsPage extends StatelessWidget {
  const BuildingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => VillageRepositoryImpl(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => VillageBloc(
                villageRepository: context.read<VillageRepositoryImpl>())
              ..add(const VillageFetchRequested(villageId: 'villageId')),
          )
        ],
        child: const BuildingsView(),
      ),
    );
  }
}

class BuildingsView extends StatefulWidget {
  const BuildingsView({super.key});

  @override
  State<BuildingsView> createState() => _BuildingsViewState();
}

class _BuildingsViewState extends State<BuildingsView>
    with TickerProviderStateMixin {
  int currentBuildingIndex = 2;
  late PageController buildingsPageController;
  AnimationController? titleController;
  double viewPortFractionTopping = 0.3;
  double? pageOffsetBuilding = 2;

  @override
  void initState() {
    buildingsPageController = PageController(
        initialPage: 2, viewportFraction: viewPortFractionTopping)
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
    return SafeArea(
      child: BlocBuilder<VillageBloc, VillageState>(
        builder: (context, state) {
          Building? specification;
          if (state.status == VillageStatus.success) {
            specification = buildingSpecefication[
                state.buildingRecords[currentBuildingIndex][1]];
          }
          return state.status == VillageStatus.loading
              ? const Scaffold(body: Center(child: CircularProgressIndicator()))
              : Scaffold(
                  backgroundColor: background,
                  appBar: AppBar(
                    centerTitle: true,
                    actions: [
                      IconButton(
                          onPressed: () {},
                          icon: const FaIcon(FontAwesomeIcons.gear))
                    ],
                    //backgroundColor: transparent,
                    elevation: 0,
                    title: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 100),
                      transitionBuilder: (child, animation) {
                        return SlideTransition(
                            position: _offsetTitle, child: child);
                      },
                      child: Column(
                        children: [
                          Text(
                            specification!.name,
                            style: font.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: black),
                          ),
                          Text(
                            'level: ${state.buildingRecords[currentBuildingIndex][2]}',
                            overflow: TextOverflow.clip,
                            style: font.copyWith(
                                fontSize: 14, color: black.withOpacity(0.8)),
                          )
                        ],
                      ),
                    ),
                  ),
                  drawer: const Drawer(),
                  bottomNavigationBar: const BottomNavBar(),
                  body: Column(
                    children: [
                      const SizedBox(
                        height: 3,
                      ),
                      StorageBar(
                        settlement: state.settlement!,
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Expanded(
                        child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: buildingWidgetsMap[specification.id]!(
                                currentBuildingIndex + 15)), //12 is a offset
                      ),
                      Divider(),
                      SizedBox(
                        height: 135,
                        width: size.width,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PageView.builder(
                              controller: buildingsPageController,
                              onPageChanged: (value) {
                                setState(() {
                                  currentBuildingIndex =
                                      value % state.buildingRecords.length;
                                  titleController!.forward(from: 0);
                                });
                              },
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          (pageOffsetBuilding! - index).abs() *
                                              40),
                                  child: BuildingPicture(
                                      key: UniqueKey(),
                                      buildingRecord: state.buildingRecords[
                                          index %
                                              state.buildingRecords.length]),
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
        },
      ),
    );
  }
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
