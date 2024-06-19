package xyz.qruto.java_server.models.responses;

import lombok.Builder;
import lombok.Data;
import xyz.qruto.java_server.models.Nations;

import java.util.List;

@Data
@Builder
public class PlayerInfo {
    private String settlementId;
    private String settlementName;
    private String playerName;
    private Nations nation;
    private List<Integer> units;
    private List<Integer> casualty;
}
