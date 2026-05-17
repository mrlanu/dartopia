package xyz.qruto.auth_server.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import xyz.qruto.auth_server.entities.RefreshTokenEntity;

import java.util.Optional;

public interface RefreshTokenRepository extends MongoRepository<RefreshTokenEntity, String> {

    Optional<RefreshTokenEntity> findByTokenAndRevokedFalse(String token);
}
