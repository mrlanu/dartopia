package xyz.qruto.java_server.services;

import org.springframework.beans.factory.annotation.Value;
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
    public String createSettings(Settings settings) {
        settingsRepository.save(settings);
        return "Settings created";
    }

    @Override
    @Cacheable("settings")
    public Settings readSettings() {
        return settingsRepository.findByServerName(serverName)
                .orElseThrow(() -> new RuntimeException(
                        String.format("Settings for server %s not found", serverName)));
    }
}
