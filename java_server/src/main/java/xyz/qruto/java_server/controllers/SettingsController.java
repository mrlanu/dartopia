package xyz.qruto.java_server.controllers;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import xyz.qruto.java_server.entities.Settings;
import xyz.qruto.java_server.services.SettingsService;

@RestController
@RequestMapping("/settings")
public class SettingsController {
    private final SettingsService settingsService;

    public SettingsController(SettingsService settingsService) {
        this.settingsService = settingsService;
    }

    @PostMapping
    public ResponseEntity<String> saveSettings(@RequestBody Settings settings) {
        return ResponseEntity.ok(settingsService.createSettings(settings));
    }

    @GetMapping
    public ResponseEntity<Settings> getSettings() {
        return ResponseEntity.ok(settingsService.readSettings());
    }
}
