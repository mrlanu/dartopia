package xyz.qruto.java_server.models;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class SideBrief {
    private String villageId;
    private String villageName;
    private String playerName;
    private String userId;
    private List<Integer> coordinates;
}
