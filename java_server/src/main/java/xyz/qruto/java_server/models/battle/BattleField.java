package xyz.qruto.java_server.models.battle;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class BattleField {
    private int tribe;
    private int population;
    @Builder.Default
    private int durBonus = 1;
    @Builder.Default
    private Wall wall = new Wall(0, 1);
    private int def;
    private boolean party;
}
