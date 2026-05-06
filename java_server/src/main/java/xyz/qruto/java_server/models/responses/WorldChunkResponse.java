package xyz.qruto.java_server.models.responses;

import lombok.Builder;
import lombok.Data;
import xyz.qruto.java_server.entities.MapTile;

import java.util.List;

@Data
@Builder
public class WorldChunkResponse {
    private int cx;
    private int cy;
    private int fromX;
    private int toX;
    private int fromY;
    private int toY;
    private List<MapTile> tiles;
}
