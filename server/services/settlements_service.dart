import 'dart:math';

import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../config/config.dart';
import '../repositories/settlement_repository.dart';
import 'utils_service.dart';

abstract class SettlementService {
  Future<List<ShortSettlementInfo>> getSettlementsIdByUserId({
    required String userId,
  });

  Future<Settlement?> fetchSettlementById({required String settlementId});

  Future<Settlement?> fetchSettlementByCoordinates({required int x,
    required int y,});

  Future<TileDetails> getTileDetailsByCoordinates({
    required int x,
    required int y,
  });

  Future<Settlement?> tryToGetSettlement({required String settlementId});

  Future<Settlement?> recalculateState({
    required String settlementId,
    DateTime? untilDateTime,
  });

  Future<Settlement?> saveSettlement({
    required Settlement settlement,
  });

  Future<Settlement?> updateSettlement({
    required Settlement settlement,
  });

  Future<String?> foundNewSettlement({
    required String userId,
  });

  Future<Settlement?> addConstructionTask(
      {required Settlement settlement, required ConstructionRequest request});

  Future<Settlement?> orderCombatUnits({required Settlement settlement,
    required OrderCombatUnitRequest request});

  Future<List<Movement>> getMovementsBeforeNow();

  Future<List<Movement>> getMovementsBySettlementId({
    required Settlement settlement,
  });

  Future<bool> sendUnits(
      {required String fromId, required SendTroopsRequest request});
}

class SettlementServiceImpl extends SettlementService {
  SettlementServiceImpl({required SettlementRepository settlementRepository})
      : _settlementRepository = settlementRepository;
  final SettlementRepository _settlementRepository;

  @override
  Future<List<ShortSettlementInfo>> getSettlementsIdByUserId(
      {required String userId}) =>
      _settlementRepository.getSettlementsIdByUserId(userId: userId);

  @override
  Future<Settlement?> fetchSettlementById(
      {required String settlementId}) async {
    return _settlementRepository.getById(settlementId);
  }

  @override
  Future<Settlement?> fetchSettlementByCoordinates(
      {required int x, required int y,}) {
    return _settlementRepository.fetchSettlementByCoordinates(x: x, y: y);
  }

  @override
  Future<TileDetails> getTileDetailsByCoordinates({
    required int x,
    required int y,
  }) {
    return _settlementRepository.getTileDetailsByCoordinates(x: x, y: y);
  }

  @override
  Future<Settlement?> tryToGetSettlement({required String settlementId}) async {
    //if settlement has any movements before DateTime.now()
    if (await _hasMovementsBeforeNow(settlementId)) {
      return null;
    }
    return recalculateState(settlementId: settlementId);
  }

  @override
  Future<Settlement?> recalculateState({
    required String settlementId,
    DateTime? untilDateTime,
  }) async {
    untilDateTime ??= DateTime.now();

    final settlement = await _settlementRepository.getById(settlementId);

    final executableTaskList = <Executable>[
      ...settlement!.constructionTasks
          .where((cTask) => cTask.when.isBefore(untilDateTime!)),
      ..._getReadyUnits(settlement, untilDateTime),
      EmptyTask(untilDateTime),
    ];

    _executeAllTasks(settlement, executableTaskList);

    return _settlementRepository.updateSettlement(settlement);
  }

  Future<bool> _hasMovementsBeforeNow(String settlementId) async {
    final movements =
    await _settlementRepository.getAllMovementsBySettlementId(settlementId);
    return movements.any((element) => element.when.isBefore(DateTime.now()));
  }

  void _executeAllTasks(Settlement settlement, List<Executable> tasks) {
    tasks.sort((a, b) => a.executionTime.compareTo(b.executionTime));
    var modified = settlement.lastModified;
    // main events loop
    for (final task in tasks) {
      var cropPerHour = settlement.calculateProducePerHour()[3];

      // if crop in the village is less than 0 keep create the death event
      // & execute them until the crop will be positive
      while (cropPerHour < 0) {
        final leftCrop = settlement.storage[3];
        final durationToDeath = leftCrop / -cropPerHour * 3600;
        final deathTime =
        modified.add(Duration(seconds: durationToDeath.toInt()));

        if (deathTime.isBefore(task.executionTime)) {
          final Executable deathEvent = DeathTask(deathTime);
          settlement.calculateProducedGoods(
              toDateTime: deathEvent.executionTime);
          deathEvent.execute(settlement);
          modified = deathEvent.executionTime;
        } else {
          break;
        }
        cropPerHour = settlement.calculateProducePerHour()[3];
      }
      // recalculate storage leftovers
      settlement
        ..calculateProducedGoods(toDateTime: task.executionTime)
        ..castStorage();
      task.execute(settlement);
      modified = task.executionTime;
    }
  }

  List<Executable> _getReadyUnits(Settlement settlement,
      DateTime untilDateTime) {
    final result = <Executable>[];
    final ordersList = settlement.combatUnitQueue;
    final newOrdersList = <CombatUtitQueue>[];

    if (ordersList.isNotEmpty) {
      for (final order in ordersList) {
        final duration = untilDateTime
            .difference(order.lastTime)
            .inSeconds;

        final endOrderTime = order.lastTime
            .add(Duration(seconds: order.leftTrain * order.durationEach));
        if (untilDateTime.isAfter(endOrderTime)) {
          // add all troops from order to result list
          result.addAll(_addCompletedCombatUnit(order, order.leftTrain));
          continue;
        }

        final completedTroops = duration ~/ order.durationEach;

        if (completedTroops > 0) {
          // add completed troops from order to result list
          result.addAll(_addCompletedCombatUnit(order, completedTroops));
          order
            ..leftTrain = order.leftTrain - completedTroops
            ..lastTime = (order.lastTime.add(
              Duration(seconds: completedTroops * order.durationEach),
            ));
        }
        newOrdersList.add(order);
      }
    }
    settlement.combatUnitQueue = newOrdersList;
    return result;
  }

  List<Executable> _addCompletedCombatUnit(CombatUtitQueue order, int amount) {
    final result = <Executable>[];
    var exec = order.lastTime;
    for (var i = 0; i < amount; i++) {
      exec = exec.add(Duration(seconds: order.durationEach));
      result.add(UnitReadyTask(order.unitId, exec));
    }
    return result;
  }

  @override
  Future<String?> foundNewSettlement({required String userId}) async {
    final newSettlement = Settlement(
      id: ObjectId(),
      userId: userId,
      x: Random().nextInt(Config.worldWidth * Config.worldHeight),
      y: Random().nextInt(Config.worldWidth * Config.worldHeight),
    );
    final result = await _settlementRepository.saveSettlement(newSettlement);
    return result?.id.$oid;
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
    required Settlement settlement,
    required ConstructionRequest request,
  }) {
    final constructionTasks = settlement.constructionTasks;
    final specification = buildingSpecefication[request.buildingId]!;
    final canBeUpgraded = specification.canBeUpgraded(
      storage: settlement.storage,
      existingBuildings: settlement.buildings,
      toLevel: request.toLevel,
    );
    if (canBeUpgraded) {
      final upgradeDuration =
      Duration(seconds: specification.time.valueOf(request.toLevel));
      final newTask = ConstructionTask(
        buildingId: request.buildingId,
        position: request.position,
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
      if (settlement.buildings[request.position][1] == 99) {
        settlement.changeBuilding(
          position: request.position,
          buildingId: 100,
          level: request.toLevel,
        );
      }
      return updateSettlement(
        settlement: settlement,
      );
    }
    return Future(() => null);
  }

  @override
  Future<Settlement?> orderCombatUnits({required Settlement settlement,
    required OrderCombatUnitRequest request}) async {
    final ordersList = settlement.combatUnitQueue;

    DateTime lastTime;
    if (ordersList.isNotEmpty) {
      final lastOrder = ordersList[ordersList.length - 1];
      lastTime = lastOrder.lastTime
          .add(Duration(seconds: lastOrder.leftTrain * lastOrder.durationEach));
    } else {
      lastTime = DateTime.now();
    }

    final order = CombatUtitQueue(
      lastTime: lastTime,
      unitId: request.unitId,
      leftTrain: request.amount,
      durationEach: 15,
    );

    // unimplemented spend resources

    settlement.addCombatUnitOrder(order);
    return updateSettlement(settlement: settlement);
  }

  @override
  Future<bool> sendUnits({
    required String fromId,
    required SendTroopsRequest request,
  }) async {
    final sender = await fetchSettlementById(settlementId: fromId);
    final receiver = await fetchSettlementById(settlementId: request.to);
    final fromSide = SideBrief(
      villageId: sender!.id.$oid,
      villageName: sender.name,
      playerName: sender.userId,
      coordinates: [sender.x, sender.y],
    );
    final toSide = SideBrief(
      villageId: receiver!.id.$oid,
      villageName: receiver.name,
      playerName: receiver.userId,
      coordinates: [receiver.x, receiver.y],
    );
    final movement = Movement(
      id: ObjectId(),
      units: request.units,
      from: fromSide,
      to: toSide,
      when: UtilsService.getArrivalTime(toX: toSide.coordinates[0],
          toY: toSide.coordinates[1],
          fromX: fromSide.coordinates[0],
          fromY: fromSide.coordinates[1],
          units: request.units,),
        mission: request.mission,
    );
    await _settlementRepository.sendUnits(movement);
    _subtractUnits(request.units, sender);
    await updateSettlement(settlement: sender);
    return
    true;
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
    final movements = await _settlementRepository
        .getAllMovementsBySettlementId(settlement.id.$oid);
    movements.add(homeLegion);
    return movements;
  }

  Movement _buildHomeLegion(Settlement settlement) {
    final fromSide = SideBrief(
      villageId: settlement.id.$oid,
      villageName: settlement.name,
      playerName: settlement.userId,
      coordinates: [90, 90],
    );
    final toSide = SideBrief(
      villageId: settlement.id.$oid,
      villageName: settlement.name,
      playerName: settlement.userId,
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
}
