package xyz.qruto.java_server.entities;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Builder
@Document("statistics")
public class StatisticsEntity {
    @Id
    private String id;
    private int position;
    private String playerName;
    @Indexed
    private String playerId;
    private int population;
    @Builder.Default
    private int villagesCount = 1;
    private String allianceName;
    private long attackPoints;
    private long defensePoints;
}
