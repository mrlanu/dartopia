package xyz.qruto.java_server.services.automation.missions;

import lombok.Data;
import lombok.EqualsAndHashCode;
import xyz.qruto.java_server.entities.Movement;
import xyz.qruto.java_server.entities.SettlementEntity;
import xyz.qruto.java_server.repositories.MovementRepository;
import xyz.qruto.java_server.services.ReportService;
import xyz.qruto.java_server.services.SettingsService;
import xyz.qruto.java_server.services.SettlementService;

import java.math.BigDecimal;

@EqualsAndHashCode(callSuper = true)
@Data
public class ReturnHomeMissionStrategy extends MissionStrategy{

    public ReturnHomeMissionStrategy(SettlementService settlementService,
                                     SettingsService settingsService,
                                     ReportService reportService,
                                     MovementRepository movementRepository,
                                     Movement movement) {
        super(settlementService, settingsService, reportService, movementRepository, movement);
    }

    @Override
    public void handle() {
        System.out.println("ReturnHomeMissionStrategy started");
        SettlementEntity homeSettlement = settlementService.recalculateSettlementWithoutSave(
                movement.getTo().getVillageId(),
                movement.getWhen());
        homeSettlement.addUnits(movement.getUnits());
        homeSettlement.addResources(movement.getPlunder()
                .stream().map(BigDecimal::valueOf).toList());
        settlementService.save(homeSettlement);
        movementRepository.delete(movement);
    }
}
