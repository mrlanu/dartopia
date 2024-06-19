package xyz.qruto.java_server.services;

import xyz.qruto.java_server.entities.MapTile;
import xyz.qruto.java_server.models.responses.TileDetails;

import java.util.List;

public interface WorldService {
    void createWorld();
    List<MapTile> getAllByCorXBetweenAndCorYBetween(int leftTopX, int leftTopY, int fromY, int toY);

    MapTile findEmptyTile();

    MapTile save(MapTile emptyTile);

    TileDetails getTileByCoordinates(int x, int y);
}
