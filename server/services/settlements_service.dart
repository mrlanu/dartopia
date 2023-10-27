import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../repositories/settlement_repository.dart';

abstract class SettlementService {
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
      {required Settlement settlement,
      required NewConstructionRequest request});
}

class SettlementServiceImpl extends SettlementService {
  SettlementServiceImpl({required SettlementRepository settlementRepository})
      : _settlementRepository = settlementRepository;
  final SettlementRepository _settlementRepository;

  @override
  Future<Settlement?> recalculateState({
    required String settlementId,
    DateTime? untilDateTime,
  }) async {
    untilDateTime ??= DateTime.now();

    final settlement = await _settlementRepository.getById(settlementId);
    final movements =
        await _settlementRepository.getAllMovementsBySettlementId(settlementId);
    settlement!.calculateProducedGoods();

    final List<Executable> executableTaskList = settlement.constructionTasks
        .where((cTask) => cTask.when.isBefore(untilDateTime!))
        .toList();

    _executeAllTasks(settlement, executableTaskList);

    return _settlementRepository.updateSettlement(settlement);
  }

  void _executeAllTasks(Settlement settlement, List<Executable> tasks) {
    var modified = settlement.lastModified;
    // main events loop
    for (var task in tasks) {
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
    final newTask = ConstructionTask(
      id: const Uuid().v4(),
      position: request.position,
      toLevel: request.toLevel,
      when: DateTime.now().add(const Duration(minutes: 1)),
    );
    settlement.addConstructionTask(newTask);
    return updateSettlement(
      settlement: settlement,
    );
  }
}
