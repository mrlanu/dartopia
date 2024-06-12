package xyz.qruto.java_server.services;

import org.springframework.stereotype.Service;
import xyz.qruto.java_server.entities.SettlementEntity;
import xyz.qruto.java_server.models.buildings.BuildingsConst;
import xyz.qruto.java_server.models.executables.ConstructionTask;
import xyz.qruto.java_server.models.requests.ConstructionRequest;
import xyz.qruto.java_server.models.responses.ShortSettlementInfo;
import xyz.qruto.java_server.repositories.MovementRepository;
import xyz.qruto.java_server.repositories.SettlementRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
public class SettlementServiceImpl implements SettlementService{

    private final SettingsService settingsService;
    private final SettlementRepository settlementRepository;
    private final MovementRepository movementRepository;

    public SettlementServiceImpl(SettingsService settingsService,
                                 SettlementRepository settlementRepository,
                                 MovementRepository movementRepository) {
        this.settingsService = settingsService;
        this.settlementRepository = settlementRepository;
        this.movementRepository = movementRepository;
    }

    @Override
    public SettlementEntity getSettlementById(String settlementId, LocalDateTime untilTime) {
        var t = movementRepository.findMovingToOrFromVillageIdBeforeDate(settlementId, LocalDateTime.now());
        if(!t.isEmpty()){
            return null;
        }
        var settlement = settlementRepository.findById(settlementId)
                .orElseThrow(() -> new IllegalArgumentException("Settlement not found"));
        settlement.update(LocalDateTime.now(), settingsService.readSettings());
        return settlementRepository.save(settlement);
    }

    private SettlementEntity recalculateSettlement(String settlementId, LocalDateTime untilTime) {
        var settlement = settlementRepository.findById(settlementId)
                .orElseThrow(() -> new IllegalArgumentException("Settlement not found"));
        settlement.update(LocalDateTime.now(), settingsService.readSettings());
        return settlement;
    }

    @Override
    public List<ShortSettlementInfo> getAllSettlementsByUserId(String userId) {
        return settlementRepository.findAllByUserId(userId).stream()
                .map(settlement -> ShortSettlementInfo.builder()
                        .name(settlement.getName())
                        .settlementId(settlement.getId())
                        .x(settlement.getX())
                        .y(settlement.getY())
                        .isCapital(false)
                        .build()).toList();
    }

    @Override
    public SettlementEntity addConstructionTask(String settlementId,
                                                ConstructionRequest constructionRequest){
        SettlementEntity settlement = recalculateSettlement(settlementId, LocalDateTime.now());
        var constructionTasks = settlement.getConstructionTasks();
        var specification = BuildingsConst.BUILDINGS
                .get(constructionRequest.getSpecificationId());
        var canBeUpgraded = specification.canBeUpgraded(
                settlement.getStorage(),
                settlement.getBuildings(),
                constructionRequest.getToLevel());

        if (canBeUpgraded) {
            var upgradeDuration = specification.getTime().valueOf(constructionRequest.getToLevel());
            var newTask = new ConstructionTask(
                    UUID.randomUUID().toString(),
                    constructionRequest.getSpecificationId(),
                    constructionRequest.getBuildingId(),
                    constructionRequest.getToLevel(),
                    constructionTasks.isEmpty()
                    ? LocalDateTime.now().plusSeconds(upgradeDuration)
                    : constructionTasks.get(constructionTasks.size() - 1)
                            .getExecutionTime().plusSeconds(upgradeDuration));
            var resToNextLevel = specification.getResourcesToNextLevel(constructionRequest.getToLevel());
            settlement.spendResources(resToNextLevel);
            settlement.addConstructionTask(newTask);
            if (settlement.getBuildings().size() == constructionRequest.getBuildingId()) {
                settlement.addConstruction(constructionRequest
                                .getBuildingId(),100, 1);
            }
            settlement.checkBuildingsForUpgradePossibility(
                    settingsService.readSettings().getMaxConstructionTasksInQueue());
            return settlementRepository.save(settlement);
        }
        return null;
    }
}
