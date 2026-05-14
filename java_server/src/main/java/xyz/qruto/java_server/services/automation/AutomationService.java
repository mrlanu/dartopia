package xyz.qruto.java_server.services.automation;

import java.util.concurrent.CompletableFuture;

public interface AutomationService {

    /**
     * Processes all overdue troop movements. Concurrent callers share one run (single-flight)
     * and each returned future completes when that run finishes.
     */
    CompletableFuture<Void> startAutomation();

    String taskB();
}
