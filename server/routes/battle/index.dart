import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

import '../../services/battle/battle.dart';
import '../../services/battle/main_battle.dart';

Response onRequest(RequestContext context) {
  final battle = Battle();
  const battleField = BattleField(tribe: 2, population: 100);
  final off = Army(side: ESide.OFF,
      population: 100,
      units: UnitsConst.UNITS[2],
      numbers: [0, 110, 0, 0, 0, 0, 0, 0, 0, 0],);
  final def = Army(side: ESide.DEF,
      population: 100,
      units: UnitsConst.UNITS[2],
      numbers: [50, 0, 0, 0, 0, 0, 0, 0, 0, 0],);

  battle.perform(battleField, [def, off]);
  return Response(body: 'This is a new route!');
}
