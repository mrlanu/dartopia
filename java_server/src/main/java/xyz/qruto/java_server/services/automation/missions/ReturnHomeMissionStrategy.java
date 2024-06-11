package xyz.qruto.java_server.services.automation.missions;

import lombok.Data;
import lombok.EqualsAndHashCode;
import xyz.qruto.java_server.entities.Movement;
import xyz.qruto.java_server.services.SettingsService;
import xyz.qruto.java_server.services.SettlementService;

@EqualsAndHashCode(callSuper = true)
@Data
public class ReturnHomeMissionStrategy extends MissionStrategy{

    public ReturnHomeMissionStrategy(SettlementService settlementService,
                                     SettingsService settingsService, Movement movement) {
        super(settlementService, settingsService, movement);
    }

    @Override
    public void handle() {

    }
}
