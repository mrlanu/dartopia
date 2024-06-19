package xyz.qruto.java_server.models.battle;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class Fns {

    private List<List<Double>> earlyRamTable = new ArrayList<>();

    public Fns() {
        generateTable();
    }

    private void generateTable() {
        for (int lvl = 0; lvl <= 20; lvl++) {
            var row = new ArrayList<Double>();
            int l;
            for (l = 0; l <= lvl / 2; l++) {
                row.add(-2 * Math.pow(l, 2) + (2 * lvl + 1) * l);
            }
            var base = lvl * (lvl + 1) / 2 + 20;
            for (; l <= lvl; l++) {
                var dl = l - Math.floor(lvl / 2.0) - 1;
                row.add(1.25 * Math.pow(dl, 2) + 49.75 * dl + base);
            }
            row.add(1e9);
            earlyRamTable.add(row);
        }
    }

    public BattleSides<Double> adducedDef(BattlePoints off, BattlePoints def) {
        var totalOff = off.getI() + off.getC();
        var infantryPart = roundPercent(off.getI() / totalOff);
        var cavalryPart = roundPercent(off.getC() / totalOff);
        var totalDef = def.getI() * infantryPart + def.getC() * cavalryPart;
        return BattleSides.off(totalOff, totalDef);
    }

    private double roundPercent(double number) {
        return Fns.roundP(1e-4, number);
    }

    public double immensity(Integer total) {
        return 1.5;
    }

    public double morale(int offPop, int defPop, double ptsRatio) {
        if (offPop <= defPop) { return 1; }
        var popRatio = offPop / Math.max(defPop, 3);
        return Math.max(0.667, Fns.roundP(1e-3, Math.pow(popRatio, -0.2 * Math.min(ptsRatio, 1))));
    }

    public static double roundP(double precision, double number){
        return precision * Math.round(number / precision);
    }

    public BattleSides<Double> raid(double x) {
        return BattleSides.off(1 / (1 + x), x / (1 + x));
    }

    public double demolishPoints(int catas, int upgLvl, int durability, double ptsRatio, double morale) {
        var effCatas = Math.floor((double) catas / (double) durability) * morale;
            return 4 * sigma(ptsRatio) * effCatas * siegeUpgrade(upgLvl);
    }

    private double sigma(double x) {
        return (x > 1 ? 2 - Math.pow(x, -1.5) : Math.pow(x, 1.5)) / 2;
    }

    private double siegeUpgrade(int level) {
        return Fns.roundP(0.005, Math.pow(1.0205, level));
    }

    public double demolishWall(int tribeDur, int level, double points) {
        var row = earlyRamTable.get(level);
        int dem = 0;
        while (Math.floor(tribeDur * row.get(dem+1)) <= points) { dem++; }
        var res = level - dem;
        return level - dem;
        }

    public int demolish(int level, double damage) {
        damage -= 0.5;
        if (damage < 0) { return level; }
        while (damage >= level && level > 0) {
            damage -= level;
            level--;
        }
        return level;
    }

    public double cataMorale(int offPopulation, int defPopulation) {
        return 1.0;
    }
}
