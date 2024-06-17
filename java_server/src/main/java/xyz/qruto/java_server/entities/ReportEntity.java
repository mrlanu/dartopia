package xyz.qruto.java_server.entities;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import xyz.qruto.java_server.models.Mission;
import xyz.qruto.java_server.models.responses.PlayerInfo;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@Document("reports")
public class ReportEntity {
    @Id
    @JsonProperty("_id")
    private String id;
    private List<ReportOwner> reportOwners;
    private Mission mission;
    private List<PlayerInfo> participants; // [off, def, ...reinforcements]
    private LocalDateTime dateTime;
    private List<Integer> bounty;
}
