package xyz.qruto.java_server.models.responses;

import lombok.Builder;
import lombok.Data;
import xyz.qruto.java_server.models.Mission;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
public class MilitaryReportResponse {
    private String id;
    private boolean failed;
    private Mission mission;
    private PlayerInfo off;
    private PlayerInfo def;
    private List<DefenseInfo> reinforcements;
    private LocalDateTime dateTime;
    private List<Integer> bounty;
}
