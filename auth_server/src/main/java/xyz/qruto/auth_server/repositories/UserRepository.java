package xyz.qruto.auth_server.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import xyz.qruto.auth_server.entities.UserEntity;

import java.util.Optional;

public interface UserRepository extends MongoRepository<UserEntity, String> {
    Optional<UserEntity> findByName(String username);
    Optional<UserEntity> findByEmail(String email);

    Boolean existsByName(String username);

    Boolean existsByEmail(String email);
}
