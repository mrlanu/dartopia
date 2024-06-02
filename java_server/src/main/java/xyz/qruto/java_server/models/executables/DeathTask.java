package xyz.qruto.java_server.models.executables;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import xyz.qruto.java_server.entities.SettlementEntity;
import xyz.qruto.java_server.models.units.UnitsConst;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DeathTask implements Executable {

    private LocalDateTime when;
    private int unitId;

    @Override
    public int execute(SettlementEntity settlement) {
        var cropOldAmount = settlement.getStorage().get(3);
        var returnedCrop = UnitsConst.UNITS
                .get(settlement.getNation().ordinal())
                .get(unitId)
                .getCost()
                .get(3);
        settlement.getStorage().set(3, cropOldAmount.add(BigDecimal.valueOf(returnedCrop)));
        var oldAmount = settlement.getUnits().get(unitId);
        settlement.getUnits().set(unitId, oldAmount - 1);
        return 0;
    }

    @Override
    public LocalDateTime getExecutionTime() {
        return when;
    }
}
