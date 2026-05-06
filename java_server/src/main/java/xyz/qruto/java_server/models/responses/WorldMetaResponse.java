package xyz.qruto.java_server.models.responses;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class WorldMetaResponse {
    private int mapWidth;
    private int mapHeight;
    private int chunkSize;
    private int chunksX;
    private int chunksY;
    /** Bump when map data or layout rules change (client may invalidate caches). */
    private long revision;
}
