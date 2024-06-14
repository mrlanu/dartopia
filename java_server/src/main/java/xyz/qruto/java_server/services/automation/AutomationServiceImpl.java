package xyz.qruto.java_server.services.automation;

import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import xyz.qruto.java_server.entities.Movement;
import xyz.qruto.java_server.repositories.MovementRepository;
import xyz.qruto.java_server.services.SettingsService;
import xyz.qruto.java_server.services.SettlementService;
import xyz.qruto.java_server.services.automation.missions.AttackMissionStrategy;
import xyz.qruto.java_server.services.automation.missions.MissionStrategy;
import xyz.qruto.java_server.services.automation.missions.ReinforcementMissionStrategy;
import xyz.qruto.java_server.services.automation.missions.ReturnHomeMissionStrategy;

import java.time.LocalDateTime;
import java.util.concurrent.locks.ReentrantLock;

@Service
public class AutomationServiceImpl implements AutomationService {

    private final ReentrantLock lock = new ReentrantLock();
    private final MovementRepository movementRepository;
    private final SettlementService settlementService;
    private final SettingsService settingsService;

    public AutomationServiceImpl(MovementRepository movementRepository,
                                 SettlementService settlementService,
                                 SettingsService settingsService) {
        this.movementRepository = movementRepository;
        this.settlementService = settlementService;
        this.settingsService = settingsService;
    }

    @Override
    @Async
    public void startAutomation() {
        try {
            lock.lock();
            var movementsList = movementRepository
                    .findAllByMovingIsTrueAndWhenIsBefore(LocalDateTime.now());

            for (Movement movement : movementsList) {
                MissionStrategy strategy = switch (movement.getMission()) {
                    case attack, raid ->
                            new AttackMissionStrategy(settlementService, settingsService,
                                    movementRepository, movement);
                    case back ->
                            new ReturnHomeMissionStrategy(settlementService, settingsService,
                                    movementRepository, movement);
                    case reinforcement ->
                            new ReinforcementMissionStrategy(settlementService, settingsService,
                                    movementRepository, movement);
                    case home, caught ->
                            throw new RuntimeException("Caught exception");
                };

                strategy.handle();
                }
        }finally {
            lock.unlock();
        }
    }

    @Override
    public String taskB() {
        return "TASK B IS RUNNING on " + Thread.currentThread().getName();
    }

    @Override
    public boolean isLocked(){
        return lock.isLocked();
    }
}
