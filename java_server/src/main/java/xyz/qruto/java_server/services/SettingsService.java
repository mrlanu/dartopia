package xyz.qruto.java_server.services;

import xyz.qruto.java_server.entities.Settings;

public interface SettingsService {
    String createSettings(Settings settings);
    Settings readSettings();
}
