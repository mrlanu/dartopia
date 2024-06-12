package xyz.qruto.java_server.entities;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document("settings")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Settings {
    @Id
    private String id;
    private String serverName;
    private int mapWidth;
    private int mapHeight;
    private int oasesAmount;
    private int troopsSpeedX;

    // after development should be deleted(should be gotten from models/UnitsConst)
    private int troopBuildDuration;
    private int maxConstructionTasksInQueue;
    private String oasisName;
    private int natureRegTime;
}
