package xyz.qruto.java_server.entities;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document("world")
@Data
@Builder
public class MapTile {
    @Id
    @JsonProperty("_id")
    private String id;
    private int corX;
    private int corY;
    private String ownerId;
    private String name;
    private int tileNumber;
    private boolean empty;
}
