import 'dart:math';

import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../server_settings.dart';

class OasesService {
  static const minUnitsForOasis = 15;
  static const maxUnitsForOasis = 30;

  static Settlement getOasis({
    required SettlementKind kind,
    required String userId,
    required int x,
    required int y,
  }) {
    return Settlement(
      id: ObjectId(),
      kind: kind,
      userId: userId,
      nation: Nations.nature,
      name: ServerSettings().oasisName,
      buildings: const [
        //------------------FIELDS----------------
        [0, 0, 10, 0], // [position, id, level, canBeUpgraded]
        [1, 1, 10, 0],
        [2, 2, 10, 0],
        [3, 3, 10, 0],
      ],
      x: x,
      y: y,
      units: OasesService.calculateSpawnedUnits(
        kind: kind, units: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],),
      availableUnits: const [],
    );
  }

  static Settlement? checkForAnimalsSpawn(Settlement settlement) {
    if (settlement.kind.isOasis) {
      final isTimeSpawnAnimals = settlement.lastSpawnedAnimals.isBefore(
        DateTime.now().subtract(
          Duration(minutes: ServerSettings().natureRegTime),
        ),
      );
      if (isTimeSpawnAnimals) {
        settlement
          ..units = calculateSpawnedUnits(
              kind: settlement.kind, units: settlement.units,)
          ..lastSpawnedAnimals = DateTime.now();
        return settlement;
      }
    }
    return null;
  }

  static List<int> calculateSpawnedUnits({
    required SettlementKind kind,
    required List<int> units,
  }) {
    switch (kind) {
      case SettlementKind.w:
        if (units[4] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[5] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[6] <= minUnitsForOasis + _getRandom(maxUnitsForOasis)) {
          units[4] = units[4] + _getRandom(15) + 5;
          units[5] = units[5] + _getRandom(5);
          units[6] = units[6] + _getRandom(5);
        }
      case SettlementKind.w_cr:
        if (units[4] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[5] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[6] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[7] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[8] <= minUnitsForOasis + _getRandom(maxUnitsForOasis)) {
          units[4] = units[4] + _getRandom(15) + 5;
          units[5] = units[5] + _getRandom(5);
          units[6] = units[6] + _getRandom(5);
          units[7] = units[7] + _getRandom(5);
          units[8] = units[8] + _getRandom(3);
        }
      case SettlementKind.c:
        if (units[0] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[1] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[4] <= minUnitsForOasis + _getRandom(maxUnitsForOasis)) {
          units[0] = units[0] + _getRandom(15) + 10;
          units[1] = units[1] + _getRandom(15) + 5;
          units[4] = units[4] + _getRandom(10);
        }
      case SettlementKind.c_cr:
        if (units[0] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[1] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[4] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[9] <= minUnitsForOasis + _getRandom(maxUnitsForOasis)) {
          units[0] = units[0] + _getRandom(20) + 15;
          units[1] = units[1] + _getRandom(15) + 10;
          units[4] = units[4] + _getRandom(10);
          units[9] = units[9] + _getRandom(3);
        }
      case SettlementKind.i:
        if (units[0] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[1] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[4] <= minUnitsForOasis + _getRandom(maxUnitsForOasis)) {
          units[0] = units[0] + _getRandom(15) + 10;
          units[1] = units[1] + _getRandom(15) + 5;
          units[4] = units[4] + _getRandom(10);
        }
      case SettlementKind.i_cr:
        if (units[0] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[1] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[4] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[8] <= minUnitsForOasis + _getRandom(maxUnitsForOasis)) {
          units[0] = units[0] + _getRandom(20) + 15;
          units[1] = units[1] + _getRandom(15) + 10;
          units[4] = units[4] + _getRandom(10);
          units[8] = units[8] + _getRandom(3);
        }
      case SettlementKind.cr:
        if (units[0] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[2] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[6] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[7] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[8] <= minUnitsForOasis + _getRandom(maxUnitsForOasis)) {
          units[0] = units[0] + _getRandom(15) + 5;
          units[2] = units[2] + _getRandom(10) + 5;
          units[6] = units[6] + _getRandom(10);
          units[7] = units[7] + _getRandom(5);
          units[8] = units[8] + _getRandom(5);
        }
      case SettlementKind.cr_cr:
        if (units[0] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[2] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[6] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[7] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[8] <= minUnitsForOasis + _getRandom(maxUnitsForOasis) ||
            units[9] <= minUnitsForOasis + _getRandom(maxUnitsForOasis)) {
          units[0] = units[0] + _getRandom(15) + 10;
          units[2] = units[2] + _getRandom(10) + 5;
          units[6] = units[6] + _getRandom(10);
          units[7] = units[7] + _getRandom(5);
          units[8] = units[8] + _getRandom(5);
          units[9] = units[9] + _getRandom(3);
        }
      case _:
        throw UnimplementedError();
    }
    return units;
  }

  static int _getRandom(int data) {
    final random = Random();
    final randomValue = random.nextInt(data);
    return randomValue;
  }
}
