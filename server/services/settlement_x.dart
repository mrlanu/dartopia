import 'package:models/models.dart';

import '../server_settings.dart';

extension SettlementX on Settlement {

  RecalculationResult recalculateState({
    required DateTime untilDateTime,
  }) {

    final executableTaskList = <Executable>[
      ...constructionTasks
          .where((cTask) => cTask.when.isBefore(untilDateTime)),
      ..._getReadyUnits(untilDateTime),
      EmptyTask(untilDateTime),
    ];

    final result = _executeAllTasks(executableTaskList);

    checkBuildingsForUpgradePossibility(
      ServerSettings().maxConstructionTasksInQueue,
    );
    return result;
  }

  RecalculationResult _executeAllTasks(List<Executable> tasks) {
    var populationAdded = 0;
    tasks.sort((a, b) => a.executionTime.compareTo(b.executionTime));
    // main events loop
    for (final task in tasks) {
      var cropPerHour = calculateProducePerHour()[3] - calculateEatPerHour();

      // if crop in the village is less than 0 keep create the death event
      // & execute them until the crop will be positive
      while (cropPerHour < 0) {
        final leftCrop = storage[3];
        final durationToDeath = leftCrop * 3600 / calculateEatPerHour();
        final deathTime =
        lastModified.add(Duration(seconds: durationToDeath.toInt()));

        if (deathTime.isBefore(task.executionTime)) {
          final Executable deathEvent = DeathTask(deathTime);
          storage[3] = 0;
          deathEvent.execute(this);
          lastModified = deathEvent.executionTime;
        } else {
          break;
        }
        cropPerHour = calculateProducePerHour()[3];
      }
      // recalculate storage leftovers
      
      calculateProducedGoods(toDateTime: task.executionTime);
      calculateEatenCrop(toDateTime: task.executionTime);
      castStorage();
      populationAdded += task.execute(this);
      lastModified = task.executionTime;
    }
    return RecalculationResult(populationAmount: populationAdded);
  }

  List<Executable> _getReadyUnits(DateTime untilDateTime,) {
    final result = <Executable>[];
    final newOrdersList = <CombatUnitQueue>[];

    if (combatUnitQueue.isNotEmpty) {
      for (final order in combatUnitQueue) {
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
    combatUnitQueue = newOrdersList;
    return result;
  }

  List<Executable> _addCompletedCombatUnit(CombatUnitQueue order, int amount) {
    final result = <Executable>[];
    var exec = order.lastTime;
    for (var i = 0; i < amount; i++) {
      exec = exec.add(Duration(seconds: order.durationEach));
      result.add(UnitReadyTask(order.unitId, exec));
    }
    return result;
  }

  void checkBuildingsForUpgradePossibility(int maxTaskQueue) {
    for (final building in buildings) {
      if (building[1] == 99 || building[1] == 100) continue;
      final canBeUpgraded = buildingSpecefication[building[1]]!
          .canBeUpgraded(storage: storage, toLevel: building[2] + 1);
      if (canBeUpgraded) {
        if (constructionTasks.length < maxTaskQueue) {
          building[3] = 1;
        } else if (constructionTasks.length == maxTaskQueue) {
          building[3] = 2;
        } else {
          building[3] = 0;
        }
      } else {
        building[3] = 0;
      }
    }
  }
}

class RecalculationResult{

  const RecalculationResult({this.populationAmount = 0});

  final int populationAmount;
}
