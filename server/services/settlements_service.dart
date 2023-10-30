import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../repositories/settlement_repository.dart';

abstract class SettlementService {
  Future<Settlement?> tryToGetSettlement({required String settlementId});

  Future<Settlement?> recalculateState({required String settlementId,
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
      {required Settlement settlement,
      required NewConstructionRequest request});

  Future<Settlement?> orderCombatUnits(
      {required Settlement settlement,
      required OrderCombatUnitRequest request});

  Future<List<Movement>> getMovementsBeforeNow();

  Future<bool> sendUnits(
      {required String fromId, required SendUnitsRequest request});
}

class SettlementServiceImpl extends SettlementService {
  SettlementServiceImpl({required SettlementRepository settlementRepository})
      : _settlementRepository = settlementRepository;
  final SettlementRepository _settlementRepository;

  @override
  Future<Settlement?> tryToGetSettlement({required String settlementId}) async {
    //if settlement has any movements before DateTime.now()
    if(await _hasMovementsBeforeNow(settlementId)) {
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

  List<Executable> _getReadyUnits(
      Settlement settlement, DateTime untilDateTime) {
    final result = <Executable>[];
    final ordersList = settlement.combatUnitQueue;
    final newOrdersList = <CombatUtitQueue>[];

    if (ordersList.isNotEmpty) {
      for (final order in ordersList) {
        final duration = untilDateTime.difference(order.lastTime).inSeconds;

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
    final newSettlement = Settlement(id: ObjectId(), userId: userId);
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
  Future<Settlement?> addConstructionTask(
      {required Settlement settlement,
      required NewConstructionRequest request}) {
    final constructionTasks = settlement.constructionTasks;
    // should be replaced with concrete Duration for particular task
    const mockDuration = Duration(minutes: 1);
    final newTask = ConstructionTask(
        id: const Uuid().v4(),
        position: request.position,
        toLevel: request.toLevel,
        when: constructionTasks.isEmpty
            ? DateTime.now().add(mockDuration)
            : constructionTasks[constructionTasks.length - 1]
                .executionTime
                .add(mockDuration));
    settlement.addConstructionTask(newTask);
    return updateSettlement(
      settlement: settlement,
    );
  }

  @override
  Future<Settlement?> orderCombatUnits(
      {required Settlement settlement,
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
  Future<bool> sendUnits(
      {required String fromId, required SendUnitsRequest request,}) async {
    final movement = Movement(
        id: ObjectId(),
        from: fromId,
        to: request.to,
        when: DateTime.now().add(const Duration(seconds: 60)),);
    return _settlementRepository.sendUnits(movement);
  }

  @override
  Future<List<Movement>> getMovementsBeforeNow() async {
    return _settlementRepository.getMovementsBeforeNow();
  }
}
