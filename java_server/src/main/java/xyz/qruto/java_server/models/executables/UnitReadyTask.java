package xyz.qruto.java_server.models.executables;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import xyz.qruto.java_server.entities.SettlementEntity;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UnitReadyTask implements Executable {
    private int unitId;
    private LocalDateTime when;

    @Override
    public int execute(SettlementEntity settlement) {
        System.out.println("Inside UnitReadyTask task execute method.");
        var oldAmount = settlement.getUnits().get(unitId);
        settlement.getUnits().set(unitId, oldAmount + 1);
        return 0;
    }

    @Override
    public LocalDateTime getExecutionTime() {
        return when;
    }


}

