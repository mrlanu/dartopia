package xyz.qruto.java_server.services.automation.missions;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import xyz.qruto.java_server.entities.Movement;
import xyz.qruto.java_server.services.SettingsService;
import xyz.qruto.java_server.services.SettlementService;

@Data
@NoArgsConstructor
public abstract class MissionStrategy {

    protected SettlementService settlementService;
    protected SettingsService settingsService;
    protected Movement movement;

    public MissionStrategy(SettlementService settlementService,
                           SettingsService settingsService, Movement movement) {
        this.settlementService = settlementService;
        this.settingsService = settingsService;
        this.movement = movement;
    }

    public abstract void handle();
}
