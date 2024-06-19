package xyz.qruto.java_server.entities;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import xyz.qruto.java_server.models.Mission;
import xyz.qruto.java_server.models.Nations;
import xyz.qruto.java_server.models.SideBrief;

import java.time.LocalDateTime;
import java.util.List;

@Document("movements")
@Data
@Builder
public class Movement {
    @Id
    @JsonProperty("_id")
    private String id;
    private boolean moving;
    private SideBrief from;
    private SideBrief to;
    private LocalDateTime when;
    private List<Integer> units;
    private List<Integer> plunder;
    private Mission mission;
    private Nations nation;
}
