package xyz.qruto.java_server.models.battle;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class BattleState {
    private BattleSides<Double> base;
    private BattleSides<Double> finale;
    private int wall;
    private double immensity;
    private int ratio;

    public BattleState() {
        this.base = BattleSides.off(0.0, 0.0);
        this.finale = BattleSides.off(0.0, 0.0);
    }

    public double getRatio(){
        return finale.getOff() / finale.getDef();
    }
}
