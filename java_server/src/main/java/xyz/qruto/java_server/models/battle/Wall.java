package xyz.qruto.java_server.models.battle;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class Wall {
    private int level;
    private int durability;

    public WallBonus<Double> getBonus(int lvl, double base){
        var defBonus = Fns.roundP(0.001, Math.pow(base, lvl)) - 1;
        return WallBonus.off(defBonus, 0.0);
    }
}
