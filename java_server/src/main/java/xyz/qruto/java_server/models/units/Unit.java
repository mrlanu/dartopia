package xyz.qruto.java_server.models.units;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class Unit {
    private UnitKind unitKind;
    private String name;
    private int offense;
    private int defenseInfantry;
    private int defenseCavalry;
    private int velocity;
    private List<Integer> cost;
    private int upKeep;
    private int time;
    private int capacity;
    private boolean infantry;
    private int researchTime;
    private String description;

    //for SPY units
    public int getS(){
        return this.getUnitKind().equals(UnitKind.SPY) ? 35 : 0;
    }

    public int getSD(){
        return this.getUnitKind().equals(UnitKind.SPY) ? 20 : 0;
    }
}
