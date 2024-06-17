package xyz.qruto.java_server.models.units;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
public class CombatUnitQueue {
    private String id;
    private LocalDateTime lastTime;
    private int unitId;
    private int leftTrain;
    private int durationEach;
}
