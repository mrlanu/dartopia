package xyz.qruto.java_server.services;

import xyz.qruto.java_server.entities.MapTile;
import xyz.qruto.java_server.models.responses.TileDetails;
import xyz.qruto.java_server.models.responses.WorldChunkResponse;
import xyz.qruto.java_server.models.responses.WorldMetaResponse;

import java.util.List;

public interface WorldService {
    void createWorld();
    List<MapTile> getAllByCorXBetweenAndCorYBetween(int fromX, int toX, int fromY, int toY);

    WorldMetaResponse getWorldMeta();

    WorldChunkResponse getChunk(int cx, int cy);

    MapTile findEmptyTile();

    MapTile save(MapTile emptyTile);

    TileDetails getTileByCoordinates(int x, int y);
}
