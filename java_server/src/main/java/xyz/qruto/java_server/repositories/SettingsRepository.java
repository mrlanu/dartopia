package xyz.qruto.java_server.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import xyz.qruto.java_server.entities.Settings;

import java.util.Optional;

public interface SettingsRepository extends MongoRepository<Settings, String> {
    Optional<Settings> findByServerName(String name);
}
