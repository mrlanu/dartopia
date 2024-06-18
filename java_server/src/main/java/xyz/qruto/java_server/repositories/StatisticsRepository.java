package xyz.qruto.java_server.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import xyz.qruto.java_server.entities.StatisticsEntity;

import java.util.Optional;

public interface StatisticsRepository extends MongoRepository<StatisticsEntity, String> {
    Optional<StatisticsEntity> findByPlayerId(String playerId);
}
