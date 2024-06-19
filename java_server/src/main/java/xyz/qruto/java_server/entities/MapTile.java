package xyz.qruto.java_server.entities;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

@Document("world")
@Data
@Builder
public class MapTile {
    @Id
    @JsonProperty("_id")
    private String id;
    @Indexed
    private int corX;
    @Indexed
    private int corY;
    private String ownerId;
    private String name;
    private int tileNumber;
    private boolean empty;
}
