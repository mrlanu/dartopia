package xyz.qruto.java_server.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import xyz.qruto.java_server.services.automation.AutomationService;

@RestController
@RequestMapping("/api/automation")
public class AutomationController {

   private final AutomationService automationService;

    public AutomationController(AutomationService automationService) {
        this.automationService = automationService;
    }

    @GetMapping
    public String getAsync() {
        automationService.startAutomation(Thread.currentThread().getName());
        automationService.taskB();
        return "Automation started";
    }
}
