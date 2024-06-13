package xyz.qruto.java_server.services;

import org.springframework.stereotype.Service;
import xyz.qruto.java_server.entities.Movement;
import xyz.qruto.java_server.entities.SettlementEntity;
import xyz.qruto.java_server.entities.UserEntity;
import xyz.qruto.java_server.models.SideBrief;
import xyz.qruto.java_server.models.buildings.BuildingsConst;
import xyz.qruto.java_server.models.executables.ConstructionTask;
import xyz.qruto.java_server.models.requests.ConstructionRequest;
import xyz.qruto.java_server.models.requests.SendTroopsRequest;
import xyz.qruto.java_server.models.requests.TroopsSendContract;
import xyz.qruto.java_server.models.responses.ShortSettlementInfo;
import xyz.qruto.java_server.repositories.MovementRepository;
import xyz.qruto.java_server.repositories.SettlementRepository;
import xyz.qruto.java_server.repositories.UserRepository;
import xyz.qruto.java_server.utils.ArrivalTimeCalculator;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@Service
public class SettlementServiceImpl implements SettlementService{

    private final SettingsService settingsService;
    private final SettlementRepository settlementRepository;
    private final MovementRepository movementRepository;
    private final UserRepository userRepository;
    private final MovementRepository managementRepository;

    public SettlementServiceImpl(SettingsService settingsService,
                                 SettlementRepository settlementRepository,
                                 MovementRepository movementRepository, UserRepository userRepository, MovementRepository managementRepository) {
        this.settingsService = settingsService;
        this.settlementRepository = settlementRepository;
        this.movementRepository = movementRepository;
        this.userRepository = userRepository;
        this.managementRepository = managementRepository;
    }

    @Override
    public SettlementEntity getSettlementById(String settlementId, LocalDateTime untilTime) {
        List<Movement> t = movementRepository.findMovingToOrFromVillageIdBeforeDate(settlementId, LocalDateTime.now());
        List<Movement> all = movementRepository.findAllByMovingIsTrueAndWhenIsBefore(LocalDateTime.now());
        var time = LocalDateTime.now();
        if(!t.isEmpty()){
            return null;
        }
        SettlementEntity settlement = settlementRepository.findById(settlementId)
                .orElseThrow(() -> new IllegalArgumentException("Settlement not found"));
        settlement.update(LocalDateTime.now(), settingsService.readSettings());
        return settlementRepository.save(settlement);
    }

    private SettlementEntity recalculateSettlement(String settlementId, LocalDateTime untilTime) {
        SettlementEntity settlement = settlementRepository.findById(settlementId)
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
            int upgradeDuration = specification.getTime().valueOf(constructionRequest.getToLevel());
            var newTask = new ConstructionTask(
                    UUID.randomUUID().toString(),
                    constructionRequest.getSpecificationId(),
                    constructionRequest.getBuildingId(),
                    constructionRequest.getToLevel(),
                    constructionTasks.isEmpty()
                    ? LocalDateTime.now().plusSeconds(upgradeDuration)
                    : constructionTasks.get(constructionTasks.size() - 1)
                            .getExecutionTime().plusSeconds(upgradeDuration));
            List<BigDecimal> resToNextLevel = specification.getResourcesToNextLevel(constructionRequest.getToLevel());
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

    @Override
    public TroopsSendContract updateContract(String fromSettlementId,
                                             TroopsSendContract contract) {
        SettlementEntity offSettlement = settlementRepository
                .findById(fromSettlementId).orElseThrow();
        SettlementEntity targetSettlement = settlementRepository
                .findByXAndY(contract.getCorX(), contract.getCorY()).orElseThrow();

        UserEntity player = userRepository.findById(targetSettlement.getUserId()).orElseThrow();
        LocalDateTime when = ArrivalTimeCalculator.getArrivalTime(
                contract.getCorX(), contract.getCorY(),
                offSettlement.getX(), offSettlement.getY(),
                contract.getUnits(), settingsService.readSettings());

        return TroopsSendContract.builder()
                .units(contract.getUnits())
                .corX(contract.getCorX())
                .corY(contract.getCorY())
                .ownerId(targetSettlement.getUserId())
                .settlementId(targetSettlement.getId())
                .name(targetSettlement.getName())
                .playerName(player.getName())
                .when(when)
                .build();
    }

    @Override
    public String sendUnits(String fromSettlementId, SendTroopsRequest request) {
        SettlementEntity senderSettlement = settlementRepository.findById(fromSettlementId).orElseThrow();
        SettlementEntity receiverSettlement = settlementRepository.findById(request.getTo()).orElseThrow();
        UserEntity senderPlayerName = userRepository.findById(senderSettlement.getUserId()).orElseThrow();
        UserEntity receiverPlayerName = userRepository.findById(receiverSettlement.getUserId()).orElseThrow();
        var fromSide = SideBrief.builder()
                .villageId(senderSettlement.getId())
                .villageName(senderSettlement.getName())
                .playerName(senderPlayerName.getName())
                .userId(senderSettlement.getUserId())
                .coordinates(Arrays.asList(senderSettlement.getX(), senderSettlement.getY()))
                .build();

        var toSide = SideBrief.builder()
                .villageId(receiverSettlement.getId())
                .villageName(receiverSettlement.getName())
                .playerName(receiverPlayerName.getName())
                .userId(receiverSettlement.getUserId())
                .coordinates(Arrays.asList(receiverSettlement.getX(), receiverSettlement.getY()))
                .build();

        LocalDateTime when = ArrivalTimeCalculator.getArrivalTime(
                toSide.getCoordinates().get(0), toSide.getCoordinates().get(1),
                fromSide.getCoordinates().get(0), fromSide.getCoordinates().get(1),
                request.getUnits(), settingsService.readSettings());
        var movement = Movement.builder()
                .moving(true)
                .units(request.getUnits())
                .from(fromSide)
                .to(toSide)
                .when(when)
                .mission(request.getMission())
                .plunder(new ArrayList<>())
                .nation(senderSettlement.getNation())
                .build();

        movementRepository.save(movement);
        senderSettlement.subtractUnits(request.getUnits());

        settlementRepository.save(senderSettlement);
        return "Units have been sent to " + receiverSettlement.getName();
    }
}
