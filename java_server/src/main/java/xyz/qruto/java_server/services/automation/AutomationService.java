package xyz.qruto.java_server.services.automation;

import org.springframework.scheduling.annotation.Async;

public interface AutomationService {
    @Async
    void startAutomation();

    String taskB();

    boolean isLocked();
}
