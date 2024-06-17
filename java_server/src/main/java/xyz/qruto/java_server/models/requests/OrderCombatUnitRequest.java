package xyz.qruto.java_server.models.requests;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class OrderCombatUnitRequest {
    private int unitId;
    private int amount;
}
