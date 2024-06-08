package xyz.qruto.java_server.services;

import xyz.qruto.java_server.entities.MapTile;

import java.util.List;

public interface WorldService {
    void createWorld();
    List<MapTile> getAllByCorXBetweenAndCorYBetween(int leftTopX, int leftTopY, int fromY, int toY);
}
