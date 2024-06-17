package xyz.qruto.java_server.services.automation.missions;

import lombok.Data;
import lombok.EqualsAndHashCode;
import xyz.qruto.java_server.entities.Movement;
import xyz.qruto.java_server.repositories.MovementRepository;
import xyz.qruto.java_server.services.ReportService;
import xyz.qruto.java_server.services.SettingsService;
import xyz.qruto.java_server.services.SettlementService;

@EqualsAndHashCode(callSuper = true)
@Data
public class ReinforcementMissionStrategy extends MissionStrategy {

    public ReinforcementMissionStrategy(SettlementService settlementService,
                                        SettingsService settingsService,
                                        ReportService reportService,
                                        MovementRepository movementRepository,
                                        Movement movement) {
        super(settlementService, settingsService, reportService, movementRepository, movement);
    }

    @Override
    public void handle() {

    }
}

