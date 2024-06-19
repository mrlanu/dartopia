package xyz.qruto.java_server.models.buildings;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class BuildingsConst {

    private static final Integer[] productions = {
            2, 5, 9, 15, 22, 33, 50, 70, 100, 145, 200,
            280, 375, 495, 635, 800, 1000, 1300, 1600,
            2000, 2450, 3050};

    private static double getProduction(int level){
        return (double)productions[level];
    }

    private static double getCapacity(int level) {
        double number = Math.pow(1.2, level) * 2120 - 1320;
        return (int) (100.0 * Math.round(number / 100.0));
    }

    private static double id(int level) {
        return (double) level;
    }

    private static double mbLike(int level){
        return Math.pow(0.964, (level - 1));
    }

    private static double train(int level){
        return Math.pow(0.9, (level - 1));
    }

    public static final Map<Integer, Building> BUILDINGS =
            Map.ofEntries(Map.entry(0, Building.builder()
                            .id(0)
                            .name("Wood")
                            .cost(Arrays.asList(40, 100, 50, 60))
                            .benefit(BuildingsConst::getProduction)
                            .k(1.67)
                            .upkeep(2)
                            .culture(1)
                            .time(new Time(1780/3,1.6, 1000/3))
                            .maxLevel(20)
                            .description("")
                            .requirementBuildings(new ArrayList<>())
                            .isMulti(true)
                            .build()),
                    Map.entry(1, Building.builder()
                            .id(1)
                            .name("Clay")
                            .cost(Arrays.asList(80, 40, 80, 50))
                            .benefit(BuildingsConst::getProduction)
                            .k(1.67)
                            .upkeep(2)
                            .culture(1)
                            .time(new Time(1660/3,1.6, 1000/3))
                            .maxLevel(22)
                            .description("")
                            .requirementBuildings(new ArrayList<>())
                            .isMulti(true)
                            .build()),
                    Map.entry(2, Building.builder()
                            .id(2)
                            .name("Iron")
                            .cost(Arrays.asList(100, 80, 30, 60))
                            .benefit(BuildingsConst::getProduction)
                            .k(1.67)
                            .upkeep(2)
                            .culture(1)
                            .time(new Time(2350/3,1.6, 1000/3))
                            .maxLevel(22)
                            .description("")
                            .requirementBuildings(new ArrayList<>())
                            .isMulti(true)
                            .build()),
                    Map.entry(3, Building.builder()
                            .id(3)
                            .name("Crops")
                            .cost(Arrays.asList(70, 90, 70, 20))
                            .benefit(BuildingsConst::getProduction)
                            .k(1.67)
                            .upkeep(0)
                            .culture(1)
                            .time(new Time(1450/3,1.6, 1000/3))
                            .maxLevel(22)
                            .description("")
                            .requirementBuildings(new ArrayList<>())
                            .isMulti(true)
                            .build()),
                    Map.entry(8, Building.builder()
                            .id(8)
                            .name("Rally point")
                            .cost(Arrays.asList(110, 160, 90, 70))
                            .benefit(BuildingsConst::id)
                            .k(1.28)
                            .upkeep(1)
                            .culture(1)
                            .time(new Time(3875))
                            .maxLevel(20)
                            .description("")
                            .requirementBuildings(new ArrayList<>())
                            .isMulti(false)
                            .build()),
                    Map.entry(4, Building.builder()
                            .id(4)
                            .name("Main office")
                            .cost(Arrays.asList(70, 40, 60, 20))
                            .benefit(BuildingsConst::mbLike)
                            .k(1.28)
                            .upkeep(2)
                            .culture(2)
                            .time(new Time(3875))
                            .maxLevel(20)
                            .description("")
                            .requirementBuildings(new ArrayList<>())
                            .isMulti(false)
                            .build()),
                    Map.entry(5, Building.builder()
                            .id(5)
                            .name("Granary")
                            .cost(Arrays.asList(80, 100, 70, 20))
                            .benefit(BuildingsConst::getCapacity)
                            .k(1.28)
                            .upkeep(1)
                            .culture(1)
                            .time(new Time(3475))
                            .maxLevel(20)
                            .description("")
                            .requirementBuildings(
                                    List.of(List.of(4, 1)))
                            .isMulti(true)
                            .build()),
                    Map.entry(6, Building.builder()
                            .id(6)
                            .name("Warehouse")
                            .cost(Arrays.asList(130, 160, 90, 40))
                            .benefit(BuildingsConst::getCapacity)
                            .k(1.28)
                            .upkeep(1)
                            .culture(1)
                            .time(new Time(3875))
                            .maxLevel(20)
                            .requirementBuildings(
                                    List.of(List.of(4, 1)))
                            .isMulti(true)
                            .build()),
                    Map.entry(7, Building.builder()
                            .id(7)
                            .name("Barracks")
                            .cost(Arrays.asList(210, 140, 260, 120))
                            .benefit(BuildingsConst::train)
                            .k(1.28)
                            .upkeep(4)
                            .culture(1)
                            .time(new Time(3875))
                            .maxLevel(20)
                            .description("")
                            .requirementBuildings(
                                    List.of(List.of(4, 1), List.of(8, 1)))
                            .isMulti(false)
                            .build()),
                    Map.entry(9, Building.builder()
                            .id(9)
                            .name("Academy")
                            .cost(Arrays.asList(220, 160,  90,  40))
                            .benefit(BuildingsConst::mbLike)
                            .k(1.28)
                            .upkeep(4)
                            .culture(4)
                            .time(new Time(3875))
                            .maxLevel(20)
                            .requirementBuildings(
                                    List.of(List.of(4, 3), List.of(7, 3)))
                            .isMulti(false)
                            .build()),
                    Map.entry(99, Building.builder()
                            .id(99)
                            .name("Empty")
                            .build()),
                    Map.entry(100, Building.builder()
                            .id(100)
                            .name("Construction")
                            .build())
            );
}

