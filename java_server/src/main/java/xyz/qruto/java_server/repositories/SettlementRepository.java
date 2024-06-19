package xyz.qruto.java_server.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import xyz.qruto.java_server.entities.SettlementEntity;

import java.util.List;
import java.util.Optional;

public interface SettlementRepository extends MongoRepository<SettlementEntity, String> {
    List<SettlementEntity> findAllByUserId(String userId);
    Optional<SettlementEntity> findByXAndY(int x, int y);
}
