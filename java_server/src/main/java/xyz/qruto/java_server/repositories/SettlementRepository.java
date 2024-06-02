package xyz.qruto.java_server.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import xyz.qruto.java_server.entities.SettlementEntity;

public interface SettlementRepository extends MongoRepository<SettlementEntity, String> {
}
