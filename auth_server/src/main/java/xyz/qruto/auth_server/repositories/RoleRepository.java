package xyz.qruto.auth_server.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import xyz.qruto.auth_server.entities.Role;
import xyz.qruto.auth_server.entities.Roles;

import java.util.Optional;

public interface RoleRepository extends MongoRepository<Role, String> {
    Optional<Role> findByName(Roles name);
}
