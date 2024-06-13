package xyz.qruto.java_server.models.requests;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
public class TroopsSendContract {
    private int corX;
    private int corY;
    private List<Integer> units;
    private String ownerId;
    private String settlementId;
    private String name;
    private String playerName;
    private LocalDateTime when;
}
