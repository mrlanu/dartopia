package xyz.qruto.java_server.models.battle;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class BattlePoints {
    private double i;
    private double c;

    public static BattlePoints off(double value, boolean isInfantry) {
        return isInfantry
                ? new BattlePoints(value, 0)
                : new BattlePoints(0, value);
    }

    public static BattlePoints add(BattlePoints a, BattlePoints b) {
        return a.add(b);
    }

    private BattlePoints add(BattlePoints that) {
        return new BattlePoints(this.i + that.i, this.c + that.c);
    }

    public BattlePoints mul(int m) {
        return new BattlePoints(this.i * m, this.c * m);
    }

    public static BattlePoints zero() {
        return new BattlePoints(0, 0);
    }
}
