package xyz.qruto.java_server.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import xyz.qruto.java_server.entities.RefreshTokenEntity;

import java.util.Optional;

public interface RefreshTokenRepository extends MongoRepository<RefreshTokenEntity, String> {

    Optional<RefreshTokenEntity> findByTokenAndRevokedFalse(String token);
}
