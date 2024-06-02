package xyz.qruto.java_server.models.buildings;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;
import java.util.function.Function;

@Data
@Builder
public class Building {
    private final int id;
    private final String name;
    private final List<Integer> cost;
    private final Time time;
    private Function<Integer, Double> benefit;
    private final double k;
    private final int upkeep;
    private final int culture;
    private final int maxLevel;
    private final String description;
    private final List<List<Integer>> requirementBuildings;
    private final boolean isMulti;
    private final String imagePath;

    public double getBenefit(int level){
        return benefit.apply(level);
    }

    public int getPopulation(int level){
        return level == 1 ? upkeep : (int) Math.round((5 * upkeep + level - 1) / 10.0);
    }

    public int getCapacity(int level) {
        double number = Math.pow(1.2, level) * 2120 - 1320;
        return (int) (100.0 * Math.round(number / 100.0));
    }

    public List<BigDecimal> getResourcesToNextLevel(int level) {
        return Arrays.asList(
                BigDecimal.valueOf(round(Math.pow(k, level - 1) * cost.get(0), 5)),
                BigDecimal.valueOf(round(Math.pow(k, level - 1) * cost.get(1), 5)),
                BigDecimal.valueOf(round(Math.pow(k, level - 1) * cost.get(2), 5)),
                BigDecimal.valueOf(round(Math.pow(k, level - 1) * cost.get(3), 5))
        );
    }

    private long round(double v, double n){
        return (long) (Math.round(v / n) * n);
    }

}
