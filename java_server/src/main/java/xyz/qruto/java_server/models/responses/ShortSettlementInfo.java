package xyz.qruto.java_server.models.responses;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ShortSettlementInfo {
    @JsonProperty("isCapital")
    private boolean isCapital;
    private String settlementId;
    private String name;
    private int x;
    private int y;
}
