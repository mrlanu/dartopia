import 'package:models/models.dart';

class DartopiaImages {
  DartopiaImages._();

  static const String lumber = 'assets/images/resources/lumber.png';
  static const String clay = 'assets/images/resources/clay.png';
  static const String iron = 'assets/images/resources/iron.png';
  static const String crop = 'assets/images/resources/crop.png';
  static const String clock = 'assets/images/resources/clock.png';
  static const String carry = 'assets/images/resources/carry.png';

  static const String rome = 'assets/images/troops/tr-0.png';
  static const String teutons = 'assets/images/troops/tr-1.png';
  static const String gauls = 'assets/images/troops/tr-2.png';
  static const String nature = 'assets/images/troops/tr-3.png';
  static const String phalang = 'assets/images/troops/spearman.png';
  static const String swordsman = 'assets/images/troops/swordsman.png';
  static const String druidrider = 'assets/images/troops/druidrider.png';
  static const String tiles = 'assets/images/resources/tiles.png';

  static const String woodField = 'assets/images/buildings/wood_new.png';
  static const String clayField = 'assets/images/buildings/clay_new.png';
  static const String ironField = 'assets/images/buildings/iron_new.png';
  static const String cropField = 'assets/images/buildings/crop_new.png';
  static const String main = 'assets/images/buildings/main_new.png';
  static const String granary = 'assets/images/buildings/granary.png';
  static const String warehouse = 'assets/images/buildings/warehouse_new.png';
  static const String barracks = 'assets/images/buildings/barracks_new.png';
  static const String rally = 'assets/images/buildings/rally_point_new.png';
  static const String academy = 'assets/images/buildings/academy_new.png';
  static const String empty = 'assets/images/buildings/empty.png';
  static const String construction = 'assets/images/buildings/construction.png';

  static const String logo = 'assets/images/logo/dartopia_logo.png';

  static String getTroopsByNation(Nations nation){
    return switch(nation){
      Nations.rome => rome,
      Nations.teuton => teutons,
      Nations.gaul => gauls,
      Nations.nature => nature,
    };
  }

}
