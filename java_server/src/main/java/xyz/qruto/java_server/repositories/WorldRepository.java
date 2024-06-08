package xyz.qruto.java_server.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import xyz.qruto.java_server.entities.MapTile;

import java.util.List;

public interface WorldRepository extends MongoRepository<MapTile, String> {
    List<MapTile> getAllByCorXBetweenAndCorYBetween(int fromX, int toX, int fromY, int toY);
}
