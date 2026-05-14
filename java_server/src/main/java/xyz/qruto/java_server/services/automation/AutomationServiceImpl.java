package xyz.qruto.java_server.services.automation;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.stereotype.Service;
import xyz.qruto.java_server.entities.Movement;
import xyz.qruto.java_server.repositories.MovementRepository;
import xyz.qruto.java_server.services.ReportService;
import xyz.qruto.java_server.services.SettingsService;
import xyz.qruto.java_server.services.SettlementService;
import xyz.qruto.java_server.services.automation.missions.AttackMissionStrategy;
import xyz.qruto.java_server.services.automation.missions.MissionStrategy;
import xyz.qruto.java_server.services.automation.missions.ReinforcementMissionStrategy;
import xyz.qruto.java_server.services.automation.missions.ReturnHomeMissionStrategy;

import java.time.LocalDateTime;
import java.util.concurrent.CompletableFuture;

@Service
public class AutomationServiceImpl implements AutomationService {

    private final Object flightMutex = new Object();
    private volatile CompletableFuture<Void> inFlight;

    private final ThreadPoolTaskExecutor automationExecutor;
    private final MovementRepository movementRepository;
    private final SettlementService settlementService;
    private final ReportService reportService;
    private final SettingsService settingsService;

    public AutomationServiceImpl(
            @Qualifier("automationTaskExecutor") ThreadPoolTaskExecutor automationExecutor,
            MovementRepository movementRepository,
            SettlementService settlementService,
            ReportService reportService,
            SettingsService settingsService) {
        this.automationExecutor = automationExecutor;
        this.movementRepository = movementRepository;
        this.settlementService = settlementService;
        this.reportService = reportService;
        this.settingsService = settingsService;
    }

    @Override
    public CompletableFuture<Void> startAutomation() {
        synchronized (flightMutex) {
            if (inFlight != null && !inFlight.isDone()) {
                return inFlight;
            }
            CompletableFuture<Void> started = CompletableFuture.runAsync(
                    this::processDueMovements,
                    automationExecutor);
            inFlight = started;
            started.whenComplete((r, ex) -> {
                synchronized (flightMutex) {
                    if (inFlight == started) {
                        inFlight = null;
                    }
                }
            });
            return started;
        }
    }

    private void processDueMovements() {
        System.out.print("Automation has been started by settlementId");
        var movementsList = movementRepository.findAllByMovingIsTrueAndWhenIsBefore(LocalDateTime.now());

        for (Movement movement : movementsList) {
            MissionStrategy strategy = switch (movement.getMission()) {
                case attack, raid ->
                        new AttackMissionStrategy(settlementService, settingsService,
                                reportService, movementRepository, movement);
                case back ->
                        new ReturnHomeMissionStrategy(settlementService, settingsService,
                                reportService, movementRepository, movement);
                case reinforcement ->
                        new ReinforcementMissionStrategy(settlementService, settingsService,
                                reportService, movementRepository, movement);
                case home, caught ->
                        throw new RuntimeException("Caught exception");
            };

            strategy.handle();
        }
    }

    @Override
    public String taskB() {
        return "TASK B IS RUNNING on " + Thread.currentThread().getName();
    }
}
