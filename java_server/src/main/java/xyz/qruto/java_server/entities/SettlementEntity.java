package xyz.qruto.java_server.entities;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import xyz.qruto.java_server.models.*;
import xyz.qruto.java_server.models.buildings.BuildingsConst;
import xyz.qruto.java_server.models.executables.*;
import xyz.qruto.java_server.models.units.CombatUnitQueue;
import xyz.qruto.java_server.models.units.UnitsConst;

import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@Data
@Document("settlements")
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Slf4j
public class SettlementEntity {
    @Id
    @JsonProperty("_id")
    private String id;
    private SettlementKind kind;
    private String userId;
    private Nations nation;
    private String name;
    private int x;
    private int y;
    private List<BigDecimal> storage;
    private List<List<Integer>> buildings;
    private List<Integer> army;
    private List<Movement> movements;
    private List<ConstructionTask> constructionTasks;
    private List<Integer> availableUnits;
    private List<CombatUnitQueue> combatUnitQueue;
    private LocalDateTime lastModified;
    private LocalDateTime lastSpawnedAnimals;

    public void update(LocalDateTime untilTime, Settings settings) {
        var events = combineAllEvents(untilTime);
        for (Executable event : events) {
            var cropPerHour = calculateProducePerHour().get(3) - calculateEatPerHour();

            // if crop in the village is less than 0 keep create the death event & execute them until the crop will be positive
            while (cropPerHour < 0) {
                var leftCrop = getStorage().get(3);
                var durationToDeath = (leftCrop.intValue() * 3_600) / calculateEatPerHour();

                LocalDateTime deathTime = lastModified.plusSeconds(durationToDeath);

                if (deathTime.isBefore(event.getExecutionTime())) {
                    Executable deathEvent = new DeathTask(deathTime, findUnitForDeath(army));
                    storage.set(3, BigDecimal.ZERO); // all crop has been eaten
                    deathEvent.execute(this);
                    lastModified = deathEvent.getExecutionTime();
                } else {
                    break;
                }
                cropPerHour = calculateProducePerHour().get(3) - calculateEatPerHour();
            }
            // recalculate storage leftovers
            calculateProducedGoods(event.getExecutionTime());
            calculateEatenCrop(event.getExecutionTime());
            castStorage();
            event.execute(this);
            lastModified = event.getExecutionTime();
        }
        checkBuildingsForUpgradePossibility(
                settings.getMaxConstructionTasksInQueue());
    }

    public void spendResources(List<BigDecimal> resources) {
        for (var i = 0; i < storage.size(); i++) {
            storage.set(i, storage.get(i).subtract(resources.get(i)));
        }
    }

    public void addResources(List<BigDecimal> resources) {
        for (var i = 0; i < storage.size(); i++) {
            storage.set(i, storage.get(i).add(resources.get(i)));
        }
    }

    public void subtractUnits(List<Integer> subtractedUnits) {
        for (int i = 0; i < 10; i++) {
            army.set(i, army.get(i) - subtractedUnits.get(i));
        }
    }

    public void addUnits(List<Integer> addedUnits) {
        for (int i = 0; i < 10; i++) {
            army.set(i, army.get(i) + addedUnits.get(i));
        }
    }

    public void addConstructionTask(ConstructionTask task) {
        constructionTasks.add(task);
    }

    public void addConstruction(int buildingId, int specificationId, int level) {
        buildings.add(Arrays.asList(buildingId, specificationId, level, 0));
    }

    public int changeBuilding(int buildingId, int specificationId, int level) {
        var index = -1;
        for (var i = 0; i < buildings.size(); i++) {
            if (buildings.get(i).get(0) == buildingId) {
                index = i;
                break;
            }
        }
        buildings.set(index, Arrays.asList(buildingId, specificationId, level, 0));
        return BuildingsConst.BUILDINGS.get(specificationId).getPopulation(level);
    }

    public void checkBuildingsForUpgradePossibility(int maxConstructionTasksInQueue) {
        for (List<Integer> building : buildings) {
            if (building.get(1) == 99 || building.get(1) == 100) continue;
            var canBeUpgraded = BuildingsConst.BUILDINGS.get(building.get(1))
          .canBeUpgraded(storage, null, building.get(2) + 1);
            if (canBeUpgraded) {
                if (constructionTasks.size() < maxConstructionTasksInQueue) {
                    building.set(3, 1);
                } else if (constructionTasks.size() == maxConstructionTasksInQueue) {
                    building.set(3, 1);
                } else {
                    building.set(3, 0);
                }
            } else {
                building.set(3, 0);
            }
        }
    }

    private List<Executable> combineAllEvents(LocalDateTime untilTime) {
        var events = getReadyUnits(untilTime);

        events.addAll(constructionTasks.stream()
                .filter(constructionTask -> constructionTask.getWhen().isBefore(untilTime))
                .toList());

        events.add(new EmptyTask(untilTime));

        return events.stream()
                .sorted(Comparator.comparing(Executable::getExecutionTime))
                .collect(Collectors.toList());
    }

    private List<Integer> calculateProducePerHour() {
        var res = buildings.stream()
                .filter(b -> b.get(1) == 0 || b.get(1) == 1 || b.get(1) == 2 || b.get(1) == 3)
                .collect(Collectors.groupingBy(subList -> subList.get(1)));
        List<Integer> result = Arrays.asList(0, 0, 0, 0);
        res.forEach((id, lists) -> {
            var sum = lists.stream().mapToInt(value -> (int) BuildingsConst.BUILDINGS.get(id).getBenefit(value.get(2))).sum();
            result.set(id, sum);
        });
        return result;
    }

    private int calculateEatPerHour() {
        return IntStream.range(0, 10)
                .mapToObj(i -> UnitsConst.UNITS.get(nation.ordinal()).get(i).getUpKeep() * army.get(i))
                .reduce(0, Integer::sum);
    }

    private void calculateProducedGoods(LocalDateTime untilTime) {
        final MathContext mc = new MathContext(3);
        List<Integer> producePerHour = calculateProducePerHour();

        long durationFromLastModified = ChronoUnit.MILLIS.between(lastModified, untilTime);

        // here is a formula for the productions counting
        // new BigDecimal((durationFromLastModified * (double) producePerHour.get(FieldType.WOOD)) / 3600000L, mc)
        BigDecimal divide = BigDecimal.valueOf(durationFromLastModified)
                .divide(BigDecimal.valueOf(3_600_000L), mc);

        BigDecimal woodProduced =
                BigDecimal.valueOf(producePerHour.get(0))
                        .multiply(divide).setScale(3, RoundingMode.HALF_DOWN);
        BigDecimal clayProduced =
                BigDecimal.valueOf(producePerHour.get(1))
                        .multiply(divide).setScale(3, RoundingMode.HALF_DOWN);
        BigDecimal ironProduced =
                BigDecimal.valueOf(producePerHour.get(2))
                        .multiply(divide).setScale(3, RoundingMode.HALF_DOWN);
        BigDecimal cropProduced =
                BigDecimal.valueOf(producePerHour.get(3))
                        .multiply(divide).setScale(3, RoundingMode.HALF_DOWN);

        storage.set(0, storage.get(0).add(woodProduced));
        storage.set(1, storage.get(1).add(clayProduced));
        storage.set(2, storage.get(2).add(ironProduced));
        storage.set(3, storage.get(3).add(cropProduced));
    }

    private void calculateEatenCrop(LocalDateTime untilTime) {
        final MathContext mc = new MathContext(3);
        var eatPerHour = calculateEatPerHour();

        long durationFromLastModified = ChronoUnit.SECONDS.between(lastModified, untilTime);

        // here is a formula for the productions counting
        // new BigDecimal((durationFromLastModified * (double) producePerHour.get(FieldType.WOOD)) / 3600000L, mc)
        BigDecimal divide = BigDecimal.valueOf(durationFromLastModified)
                .divide(BigDecimal.valueOf(3_600L), mc);

        BigDecimal eatenCrop = BigDecimal.valueOf(eatPerHour).multiply(divide);
        storage.set(3, storage.get(3).subtract(eatenCrop));
        if (storage.get(3).intValue() < 0) storage.set(3, BigDecimal.ZERO);
    }

    private BigDecimal getWarehouseCapacity() {
        double warehouse = buildings.stream()
                .filter(b -> b.get(1).equals(6))
                .map(b -> BuildingsConst.BUILDINGS.get(b.get(1)).getBenefit(b.get(2)))
                .reduce(0.0, Double::sum);
        return warehouse > 0.0 ? BigDecimal.valueOf(warehouse) : BigDecimal.valueOf(800);
    }

    private BigDecimal getGranaryCapacity() {
        double granary = buildings.stream()
                .filter(b -> b.get(1).equals(5))
                .map(b -> BuildingsConst.BUILDINGS.get(b.get(1)).getBenefit(b.get(2)))
                .reduce(0.0, Double::sum);
        return granary > 0.0 ? BigDecimal.valueOf(granary) : BigDecimal.valueOf(800);
    }

    private void castStorage() {
        var warehouseCapacity = getWarehouseCapacity();
        var granaryCapacity = getGranaryCapacity();
        for (int i = 0; i < storage.size() - 1; i++) {
            if (storage.get(i).compareTo(warehouseCapacity) > 0) {
                storage.set(i, warehouseCapacity);
            }
            // cast crop
            if (storage.get(3).compareTo(granaryCapacity) > 0) {
                storage.set(3, granaryCapacity);
            }
        }
    }

    private void manipulateHomeLegion(List<Integer> newUnits) {
        for (int i = 0; i < army.size(); i++) {
            army.set(i, army.get(i) + newUnits.get(i));
        }
    }

    private List<Executable> getReadyUnits(LocalDateTime untilDateTime) {
        List<Executable> result = new ArrayList<>();
        List<CombatUnitQueue> newOrdersList = new ArrayList<>();

        if (!combatUnitQueue.isEmpty()) {
            for (CombatUnitQueue order : combatUnitQueue) {
                long durationInSeconds = Duration.between(order.getLastTime(), untilDateTime).getSeconds();

                LocalDateTime endOrderTime = order.getLastTime().plusSeconds((long) order.getLeftTrain() * order.getDurationEach());
                if (untilDateTime.isAfter(endOrderTime)) {
                    // add all troops from order to result list
                    result.addAll(addCompletedCombatUnit(order, order.getLeftTrain()));
                    continue;
                }

                int completedTroops = (int) (durationInSeconds / order.getDurationEach());

                if (completedTroops > 0) {
                    // add completed troops from order to result list
                    result.addAll(addCompletedCombatUnit(order, completedTroops));
                    order.setLeftTrain(order.getLeftTrain() - completedTroops);
                    order.setLastTime(order.getLastTime().plusSeconds((long) completedTroops * order.getDurationEach()));
                }
                newOrdersList.add(order);
            }
        }
        combatUnitQueue = newOrdersList;
        return result;
    }

    private List<Executable> addCompletedCombatUnit(CombatUnitQueue order, int amount) {
        List<Executable> result = new ArrayList<>();
        LocalDateTime exec = order.getLastTime();
        for (int i = 0; i < amount; i++) {
            exec = exec.plusSeconds(order.getDurationEach());
            result.add(new UnitReadyTask(order.getUnitId(), exec));
        }
        return result;
    }

    private int findUnitForDeath(List<Integer> list) {
        for (int i = 0; i < list.size(); i++) {
            if (list.get(i) != 0) {
                return i;
            }
        }
        return -1; // Return -1 if no non-zero element is found
    }
}
