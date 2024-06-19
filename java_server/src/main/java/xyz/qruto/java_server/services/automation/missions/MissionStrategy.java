package xyz.qruto.java_server.services.automation.missions;

import lombok.Data;
import lombok.NoArgsConstructor;
import xyz.qruto.java_server.entities.Movement;
import xyz.qruto.java_server.repositories.MovementRepository;
import xyz.qruto.java_server.services.ReportService;
import xyz.qruto.java_server.services.SettingsService;
import xyz.qruto.java_server.services.SettlementService;

@Data
@NoArgsConstructor
public abstract class MissionStrategy {

    protected SettlementService settlementService;
    protected SettingsService settingsService;
    protected ReportService reportService;
    protected MovementRepository movementRepository;
    protected Movement movement;

    public MissionStrategy(SettlementService settlementService,
                           SettingsService settingsService,
                           ReportService reportService,
                           MovementRepository movementRepository,
                           Movement movement) {
        this.settlementService = settlementService;
        this.settingsService = settingsService;
        this.reportService = reportService;
        this.movementRepository = movementRepository;
        this.movement = movement;
    }

    public abstract void handle();
}
