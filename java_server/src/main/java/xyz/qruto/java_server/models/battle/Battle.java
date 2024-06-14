package xyz.qruto.java_server.models.battle;

import lombok.Data;
import xyz.qruto.java_server.models.Mission;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Data
public class Battle {
    private BattleField battleField;
    private Army offArmy;
    private List<Army> defArmies;
    private final int BASE_VILLAGE_DEF = 10;
    private BattleState battleState;
    private BattleResult battleResult;
    private Fns fns;

    public Battle() {
        this.defArmies = new ArrayList<>();
        this.battleState = new BattleState();
        this.battleResult = new BattleResult();
        this.fns = new Fns();
    }

    public List<BattleResult> perform(BattleField battleField, List<Army> sides){
        this.battleField = battleField;
        var results = new ArrayList<BattleResult>();
        for (Army side : sides){
            if (side.getSide().equals(Army.ESide.DEF)){
                defArmies.add(side);
            } else {
                offArmy = side;
                wave();
                defArmies.forEach(d -> d.applyLosses(battleResult.getDefLosses(), battleResult));
                offArmy.applyLosses(battleResult.getOffLoses(), battleResult);
                results.add(battleResult);
            }
        }
        return results;
    }
    private void wave() {
        battleResult = new BattleResult(0, 0, battleField.getWall().getLevel());
        battleState.setWall(battleField.getWall().getLevel());
        if (offArmy.isScan()){
            scan();
        }else if (offArmy.getMission().equals(Mission.raid)){
            raid();
        }else {
            normal();
        }
        loneAttackerDies();
    }

    private void scan() {
        var offPoints = offArmy.getScan() * morale(false);
        var defPoints = defArmies.stream()
                .reduce(0.0, (a, b) -> a + b.getScanDef(), Double::sum) * getDefBonus();
        var losses = Math.min(Math.pow((defPoints / offPoints), 1.5), 1);
        battleResult.setOffLoses(losses);
        battleResult.setDefLosses(0.0);
    }

    private void raid() {
        calcBasePoints();
        calcTotalPoints();
        var x = calcRatio();
        var pair = fns.raid(x);
        battleResult.setOffLoses(pair.getOff());
        battleResult.setDefLosses(pair.getDef());
    }

    private double calcRatio() {
        return Math.pow(battleState.getRatio(),  battleState.getImmensity());
    }

    private void normal() {
        calcBasePoints();
        calcTotalPoints();
        calcRams();
        var x = this.calcRatio();
        battleResult.setOffLoses(Math.min(1/x, 1));
        battleResult.setDefLosses(Math.min(x, 1));
        calcCatapults();
    }

    private void calcCatapults() {
        var targets = offArmy.getTargets();
        if (targets.isEmpty()) { return; }
        var morale = this.cataMorale();
        int[] cats = offArmy.cats();
        var points = fns.demolishPoints(
                cats[0] / targets.size(),
                cats[1],
                battleField.getDurBonus(),
                battleState.getRatio(),
                morale
                );
        battleResult.setBuildings(
                offArmy.getTargets().stream()
                        .map(b -> fns.demolish(b, points)).collect(Collectors.toList()));
    }

    private double cataMorale() {
        return fns.cataMorale(offArmy.getPopulation(), battleField.getPopulation());
    }

    private void calcRams() {
        int[] rams = offArmy.rams();
        if (rams.length == 0 || battleState.getWall() == 0) { return; }
        var wall = battleField.getWall();
        var earlyPoints = fns
                .demolishPoints(rams[0], rams[1], battleField.getDurBonus(), battleState.getRatio(), 1);
        var demolishWall = fns.demolishWall(wall.getDurability(), wall.getLevel(), earlyPoints);
        battleState.setWall((int) demolishWall);
        calcTotalPoints();
        var points = fns
                .demolishPoints(rams[0], rams[1], battleField.getDurBonus(), battleState.getRatio(), 1);
        battleResult.setWall(fns.demolish(wall.getLevel(), points));
    }

    private void loneAttackerDies() {
        if (offArmy.getTotal() == 1) {
            var offPair = offArmy.getOff();
            var off = offPair.getI() + offPair.getC();
            var morale = morale(false);
            if (off * morale < 84.5) { battleResult.setOffLoses(1); }
        }
    }

    private void calcBasePoints() {
        var offPts = offArmy.getOff();
        var defPts = defArmies.stream().map(Army::getDef).reduce(BattlePoints::add).orElseThrow();
        battleState.setBase(fns.adducedDef(offPts, defPts));
        var total = defArmies.stream().reduce(offArmy.getTotal(), (i, a) -> i + a.getTotal(), Integer::sum);
        battleState.setImmensity(fns.immensity(total));
    }

    private void calcTotalPoints() {
        calcDefBonuses();
        battleState.getFinale().setOff(battleState.getBase().getOff());
        var morale = morale(true);
        battleState.getFinale().setOff(battleState.getBase().getOff() * morale);
    }

    private double morale(boolean remorale) {
        return fns.morale(
                offArmy.getPopulation(),
                battleField.getPopulation(),
                remorale ? (battleState.getFinale().getOff() / battleState.getFinale().getDef()) : 1.0);
    }

    private void calcDefBonuses() {
        var result = (this.battleState.getBase().getDef() + getDefAbsolute()) * getDefBonus();
        battleState.getFinale().setDef(result);
    }

    private double getDefBonus() {
        return 1 + battleField.getWall().getBonus(battleState.getWall(), 1.03).getDefBonus();
    }

    private Double getDefAbsolute() {
        return BASE_VILLAGE_DEF
                + battleField.getDef()
                + battleField.getWall().getBonus(battleState.getWall(), 1.03).getDef();
    }
}
