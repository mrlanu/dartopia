import 'dart:async';
import 'dart:math';

import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../repositories/settlement_repository.dart';
import '../repositories/statistics_repository.dart';
import '../repositories/user_repository.dart';
import '../server_settings.dart';
import 'settlement_x.dart';
import 'utils_service.dart';

abstract class SettlementService {
  Future<List<ShortSettlementInfo>> getSettlementsIdByUserId({
    required String userId,
  });

  Future<Settlement?> fetchSettlementById({required String settlementId});

  Future<Settlement?> fetchSettlementByCoordinates({
    required int x,
    required int y,
  });

  Future<TileDetails> getTileDetailsByCoordinates({
    required int x,
    required int y,
  });

  Future<Settlement?> tryToGetSettlement({required String settlementId});

  Future<Settlement> recalculateState({
    required String settlementId,
    required DateTime untilDateTime,
  });

  Future<Settlement?> saveSettlement({
    required Settlement settlement,
  });

  Future<Settlement?> updateSettlement({
    required Settlement settlement,
  });

  Future<Settlement?> foundNewSettlement({
    required String userId,
  });

  Future<Settlement?> addConstructionTask({
    required String settlementId,
    required ConstructionRequest request,
  });

  Future<Settlement?> orderCombatUnits({
    required String settlementId,
    required OrderCombatUnitRequest request,
  });

  Future<List<Movement>> getMovementsBeforeNow();

  Future<List<Movement>> getMovementsBySettlementId({
    required Settlement settlement,
  });

  Future<List<Movement>> getAllStaticForeignMovementsBySettlementId(String id);

  Future<bool> sendUnits({
    required String fromId,
    required SendTroopsRequest request,
  });

  Future<void> reorderBuildings({
    required String settlementId,
    required List<List<int>> buildings,
  });

  Future<TroopsSendContract> updateContract(
    String fromSettlementId,
    TroopsSendContract contract,
  );
}

class SettlementServiceImpl extends SettlementService {
  SettlementServiceImpl({
    required SettlementRepository settlementRepository,
    required StatisticsRepository statisticsRepository,
    required UserRepository userRepository,
  })  : _settlementRepository = settlementRepository,
        _statisticsRepository = statisticsRepository,
        _userRepository = userRepository;
  final SettlementRepository _settlementRepository;
  final StatisticsRepository _statisticsRepository;
  final UserRepository _userRepository;

  @override
  Future<List<ShortSettlementInfo>> getSettlementsIdByUserId({
    required String userId,
  }) =>
      _settlementRepository.getSettlementsIdByUserId(userId: userId);

  @override
  Future<Settlement?> fetchSettlementById({
    required String settlementId,
  }) async {
    return _settlementRepository.getById(settlementId);
  }

  @override
  Future<Settlement?> fetchSettlementByCoordinates({
    required int x,
    required int y,
  }) {
    return _settlementRepository.fetchSettlementByCoordinates(x: x, y: y);
  }

  @override
  Future<TileDetails> getTileDetailsByCoordinates({
    required int x,
    required int y,
  }) async {
    final settlement =
        await _settlementRepository.getSettlementByCoordinates(x: x, y: y);

    unawaited(_checkForAnimalsSpawn(settlement));

    return TileDetails(
      id: settlement.id.$oid,
      playerName: settlement.userId,
      name: settlement.name,
      x: settlement.x,
      y: settlement.y,
      population: 100,
      distance: 3,
    );
  }

  @override
  Future<Settlement?> tryToGetSettlement({required String settlementId}) async {
    //if settlement has any movements before DateTime.now()
    final hasMovements = await _hasMovementsBeforeNow(settlementId);
    if (hasMovements) {
      return null;
    }
    final settlement = await recalculateState(
      settlementId: settlementId,
      untilDateTime: DateTime.now(),
    );
    await updateSettlement(settlement: settlement);

    final movements = await getMovementsBySettlementId(
      settlement: settlement,
    );
    return settlement.copyWith(movements: movements);
  }

  @override
  Future<Settlement> recalculateState({
    required String settlementId,
    required DateTime untilDateTime,
  }) async {
    final settlement = await _settlementRepository.getById(settlementId);
    final result = settlement!.recalculateState(untilDateTime: untilDateTime);
    if (result.populationAmount > 0) {
      unawaited(
        _statisticsRepository.addPopulation(
          playerId: settlement.userId,
          amount: result.populationAmount,
        ),
      );
    }
    return settlement;
  }

  Future<bool> _hasMovementsBeforeNow(String settlementId) async {
    final movements = await _settlementRepository.getAllMovementsBySettlementId(
      id: settlementId,
      isMoving: true,
    );
    return movements.any((element) => element.when.isBefore(DateTime.now()));
  }

  @override
  Future<Settlement?> foundNewSettlement({required String userId}) async {
    final newSettlement = Settlement(
      id: ObjectId(),
      userId: userId,
      nation: Nations.gaul,
      x: _getRandomNumber(4, ServerSettings().mapWidth - 4),
      y: _getRandomNumber(4, ServerSettings().mapHeight - 4),
    );
    await _settlementRepository.saveSettlement(newSettlement);
    return newSettlement;
  }

  int _getRandomNumber(int min, int max) {
    final random = Random();
    return min + random.nextInt((max - min) + 1);
  }

  @override
  Future<Settlement?> saveSettlement({required Settlement settlement}) async {
    return _settlementRepository.saveSettlement(settlement);
  }

  @override
  Future<Settlement?> updateSettlement({required Settlement settlement}) {
    return _settlementRepository.updateSettlement(settlement);
  }

  @override
  Future<Settlement?> addConstructionTask({
    required String settlementId,
    required ConstructionRequest request,
  }) async {
    final settlement = await recalculateState(
      settlementId: settlementId,
      untilDateTime: DateTime.now(),
    );

    final constructionTasks = settlement.constructionTasks;
    final specification = buildingSpecefication[request.specificationId]!;
    final canBeUpgraded = specification.canBeUpgraded(
      storage: settlement.storage,
      existingBuildings: settlement.buildings,
      toLevel: request.toLevel,
    );
    if (canBeUpgraded) {
      final upgradeDuration =
          Duration(seconds: specification.time.valueOf(request.toLevel));
      final newTask = ConstructionTask(
        specificationId: request.specificationId,
        buildingId: request.buildingId,
        toLevel: request.toLevel,
        when: constructionTasks.isEmpty
            ? DateTime.now().add(upgradeDuration)
            : constructionTasks[constructionTasks.length - 1]
                .executionTime
                .add(upgradeDuration),
      );
      settlement
        ..spendResources(specification.getResourcesToNextLevel(request.toLevel))
        ..addConstructionTask(newTask);
      if (settlement.buildings.length == request.buildingId) {
        settlement.addConstruction(
          buildingId: request.buildingId,
          specificationId: 100,
          level: 1,
        );
      }
      settlement.checkBuildingsForUpgradePossibility(
        ServerSettings().maxConstructionTasksInQueue,
      );
      return updateSettlement(settlement: settlement);
    }
    return Future(() => null);
  }

  @override
  Future<Settlement?> orderCombatUnits({
    required String settlementId,
    required OrderCombatUnitRequest request,
  }) async {
    final settlement = await recalculateState(
      settlementId: settlementId,
      untilDateTime: DateTime.now(),
    );
    final ordersList = settlement.combatUnitQueue;

    DateTime lastTime;
    if (ordersList.isNotEmpty) {
      final lastOrder = ordersList.last;
      lastTime = lastOrder.lastTime
          .add(Duration(seconds: lastOrder.leftTrain * lastOrder.durationEach));
    } else {
      lastTime = DateTime.now();
    }

    final order = CombatUnitQueue(
      lastTime: lastTime,
      unitId: request.unitId,
      leftTrain: request.amount,
      durationEach: ServerSettings().troopBuildDuration,
    );

    final unit = UnitsConst.UNITS[settlement.nation.index][order.unitId];
    final costOfAll =
        unit.cost.map((price) => price * order.leftTrain).toList();
    settlement
      ..spendResources(costOfAll)
      ..addCombatUnitOrder(order);
    return updateSettlement(settlement: settlement);
  }

  @override
  Future<TroopsSendContract> updateContract(
    String fromSettlementId,
    TroopsSendContract contract,
  ) async {
    final offSettlement =
        await fetchSettlementById(settlementId: fromSettlementId);
    final targetSettlement = await fetchSettlementByCoordinates(
      x: contract.corX,
      y: contract.corY,
    );

    final player = await _userRepository.findById(id: targetSettlement!.userId);
    final when = UtilsService.getArrivalTime(
      toX: contract.corX,
      toY: contract.corY,
      fromX: offSettlement!.x,
      fromY: offSettlement.y,
      units: contract.units,
    );
    return contract.copyWith(
      ownerId: targetSettlement.userId,
      settlementId: targetSettlement.id.$oid,
      name: targetSettlement.name,
      playerName: player!.name,
      when: when,
    );
  }

  @override
  Future<bool> sendUnits({
    required String fromId,
    required SendTroopsRequest request,
  }) async {
    final senderSettlement = await fetchSettlementById(settlementId: fromId);
    final receiverSettlement =
        await fetchSettlementById(settlementId: request.to);
    final senderPlayerName = await _userRepository.findById(
      id: senderSettlement!.userId,
    );
    final receiverPlayerName =
        await _userRepository.findById(id: receiverSettlement!.userId);
    final fromSide = SideBrief(
      villageId: senderSettlement.id.$oid,
      villageName: senderSettlement.name,
      playerName: senderPlayerName!.name,
      userId: senderSettlement.userId,
      coordinates: [senderSettlement.x, senderSettlement.y],
    );
    final toSide = SideBrief(
      villageId: receiverSettlement.id.$oid,
      villageName: receiverSettlement.name,
      playerName: receiverPlayerName!.name,
      userId: receiverSettlement.userId,
      coordinates: [receiverSettlement.x, receiverSettlement.y],
    );
    final movement = Movement(
      id: ObjectId(),
      units: request.units,
      from: fromSide,
      to: toSide,
      when:
          //DateTime.now().add(const Duration(seconds: 30)),
          UtilsService.getArrivalTime(
        toX: toSide.coordinates[0],
        toY: toSide.coordinates[1],
        fromX: fromSide.coordinates[0],
        fromY: fromSide.coordinates[1],
        units: request.units,
      ),
      mission: request.mission,
    );
    await _settlementRepository.sendUnits(movement);
    _subtractUnits(request.units, senderSettlement);
    await updateSettlement(settlement: senderSettlement);
    return true;
  }

  void _subtractUnits(List<int> units, Settlement home) {
    final homeUnits = home.units;
    for (var i = 0; i < 10; i++) {
      var amount = homeUnits[i];
      amount -= units[i];
      homeUnits[i] = amount;
    }
  }

  @override
  Future<List<Movement>> getMovementsBeforeNow() async {
    return _settlementRepository.getMovementsBeforeNow();
  }

  @override
  Future<List<Movement>> getMovementsBySettlementId({
    required Settlement settlement,
  }) async {
    final homeLegion = _buildHomeLegion(settlement);
    final movements = await _settlementRepository.getAllMovementsBySettlementId(
      id: settlement.id.$oid,
    );
    movements.add(homeLegion);
    return movements;
  }

  @override
  Future<List<Movement>> getAllStaticForeignMovementsBySettlementId(
    String id,
  ) =>
      _settlementRepository.getAllStaticForeignMovementsBySettlementId(id);

  Movement _buildHomeLegion(Settlement settlement) {
    final fromSide = SideBrief(
      villageId: settlement.id.$oid,
      villageName: settlement.name,
      playerName: settlement.userId,
      userId: settlement.userId,
      coordinates: [90, 90],
    );
    final toSide = SideBrief(
      villageId: settlement.id.$oid,
      villageName: settlement.name,
      playerName: settlement.userId,
      userId: settlement.userId,
      coordinates: [90, 90],
    );
    return Movement(
      id: ObjectId(),
      isMoving: false,
      from: fromSide,
      to: toSide,
      units: settlement.units,
      when: DateTime.now(),
      mission: Mission.home,
    );
  }

  @override
  Future<void> reorderBuildings({
    required String settlementId,
    required List<List<int>> buildings,
  }) async {
    final settlement = await fetchSettlementById(settlementId: settlementId);
    settlement!.reorderBuildings(buildings);
    await _settlementRepository.updateSettlementWithoutLastModified(settlement);
  }

  Future<void> _checkForAnimalsSpawn(Settlement settlement) async {
    if (settlement.kind.isOasis) {
      final isTimeSpawnAnimals = settlement.lastSpawnedAnimals.isBefore(
        DateTime.now().subtract(
          Duration(minutes: ServerSettings().natureRegTime),
        ),
      );
      if (isTimeSpawnAnimals) {
        settlement
          ..units = const [10, 0, 0, 5, 0, 0, 0, 0, 0, 0]
          ..lastSpawnedAnimals = DateTime.now();
        await _settlementRepository
            .updateSettlementWithoutLastModified(settlement);
      }
    }
  }
}
