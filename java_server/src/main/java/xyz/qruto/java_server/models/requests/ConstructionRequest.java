package xyz.qruto.java_server.models.requests;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class ConstructionRequest {
    private int specificationId;
    private int buildingId;
    private int toLevel;
}
