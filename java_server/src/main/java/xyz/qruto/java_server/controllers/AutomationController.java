package xyz.qruto.java_server.controllers;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import xyz.qruto.java_server.services.automation.AutomationService;

import java.util.concurrent.CompletionException;

@RestController
@RequestMapping("/api/automation")
public class AutomationController {

   private final AutomationService automationService;

    public AutomationController(AutomationService automationService) {
        this.automationService = automationService;
    }

    @GetMapping
    public String getAsync() {
        try {
            automationService.startAutomation().join();
        } catch (CompletionException e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
                    "Automation failed", e.getCause());
        }
        return automationService.taskB();
    }
}
