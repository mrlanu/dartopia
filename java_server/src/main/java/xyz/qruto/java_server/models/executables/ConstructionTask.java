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
        var building = settlement.getBuildings().stream()
                .filter(b -> b.get(0) == buildingId).findFirst().orElseThrow();
        building.set(2, building.get(2) + 1);
        return 0;
    }

    @Override
    public LocalDateTime getExecutionTime() {
        return when;
    }
}
