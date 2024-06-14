package xyz.qruto.java_server.models.battle;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class BattleResult {
    private double offLoses;
    private double defLosses;
    private List<Integer> buildings;
    private int wall;
    private List<List<Integer>> unitsBeforeBattle;
    private List<List<Integer>> casualties;

    public BattleResult(double offLoses, double defLosses, int wall) {
        this.offLoses = offLoses;
        this.defLosses = defLosses;
        this.buildings = new ArrayList<>();
        this.wall = wall;
        this.unitsBeforeBattle = new ArrayList<>();
        this.casualties = new ArrayList<>();
    }
}
