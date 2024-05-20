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
  static const String phalang = 'assets/images/troops/t1.png';
  static const String tiles = 'assets/images/resources/tiles.png';

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
