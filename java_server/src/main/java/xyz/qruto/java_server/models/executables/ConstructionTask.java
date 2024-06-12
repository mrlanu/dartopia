package xyz.qruto.java_server.models.executables;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import xyz.qruto.java_server.entities.SettlementEntity;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ConstructionTask implements Executable {
    private String id;
    private int specificationId;
    private int buildingId;
    private int toLevel;
    private LocalDateTime when;

    @Override
    public int execute(SettlementEntity settlement) {
        var statPoints = settlement.changeBuilding(buildingId, specificationId, toLevel);
        // remove executed Task
        settlement.getConstructionTasks().remove(this);
        return statPoints;
    }

    @Override
    public LocalDateTime getExecutionTime() {
        return when;
    }
}
