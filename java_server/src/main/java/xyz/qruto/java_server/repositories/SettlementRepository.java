package xyz.qruto.java_server.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import xyz.qruto.java_server.entities.SettlementEntity;

import java.util.List;

public interface SettlementRepository extends MongoRepository<SettlementEntity, String> {
    List<SettlementEntity> findAllByUserId(String userId);
}
