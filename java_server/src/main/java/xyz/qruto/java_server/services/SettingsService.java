package xyz.qruto.java_server.services;

import xyz.qruto.java_server.entities.Settings;

public interface SettingsService {
    String createSettings(Settings settings);

    /**
     * Loads settings for the configured {@code myapp.settings.server-name}, creating a default
     * MongoDB document on first access when none exists.
     */
    Settings readSettings();
}
