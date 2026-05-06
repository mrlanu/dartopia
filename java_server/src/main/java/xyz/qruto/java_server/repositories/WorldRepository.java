package xyz.qruto.java_server.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import xyz.qruto.java_server.entities.MapTile;

import java.util.List;

public interface WorldRepository extends MongoRepository<MapTile, String> {
    /**
     * Inclusive rectangle on both axes. Spring's derived {@code Between} for MongoDB uses
     * exclusive bounds ({@code $gt}/{@code $lt}), which drops every chunk edge (e.g. 16, 32)
     * and the outermost map coordinates (water rim).
     */
    @Query("{ 'corX': { $gte: ?0, $lte: ?1 }, 'corY': { $gte: ?2, $lte: ?3 } }")
    List<MapTile> getAllByCorXBetweenAndCorYBetween(int fromX, int toX, int fromY, int toY);
    MapTile getByCorXAndCorY(int corX, int corY);
}
