package xyz.qruto.java_server.services;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import xyz.qruto.java_server.entities.Settings;
import xyz.qruto.java_server.repositories.SettingsRepository;

@Service
public class SettingsServiceImpl implements SettingsService {
    private final SettingsRepository settingsRepository;

    @Value("${myapp.settings.server-name}")
    private String serverName;

    public SettingsServiceImpl(SettingsRepository settingsRepository) {
        this.settingsRepository = settingsRepository;
    }

    @Override
    @CacheEvict(value = "settings", allEntries = true)
    public String createSettings(Settings settings) {
        settingsRepository.save(settings);
        return "Settings created";
    }

    /**
     * Returns persisted settings for the configured server name, inserting a default document
     * when none exist.
     */
    @Override
    @Cacheable(value = "settings", sync = true)
    public Settings readSettings() {
        return settingsRepository.findByServerName(serverName)
                .orElseGet(() -> settingsRepository.save(buildDefaultSettings()));
    }

    /** Initial row when the {@code settings} collection has no entry for this server. */
    private Settings buildDefaultSettings() {
        return Settings.builder()
                .serverName(serverName)
                .mapWidth(100)
                .mapHeight(100)
                .chunkSize(16)
                .oasesAmount(100)
                .troopsSpeedX(10)
                .minUnitsForOasis(15)
                .maxUnitsForOasis(30)
                .troopBuildDuration(180)
                .maxConstructionTasksInQueue(2)
                .oasisName("Unoccupied Oasis")
                .natureRegTime(4)
                .build();
    }
}
