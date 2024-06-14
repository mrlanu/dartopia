package xyz.qruto.java_server.services.automation.missions;

import lombok.Data;
import lombok.EqualsAndHashCode;
import xyz.qruto.java_server.entities.Movement;
import xyz.qruto.java_server.entities.SettlementEntity;
import xyz.qruto.java_server.models.Mission;
import xyz.qruto.java_server.models.battle.Army;
import xyz.qruto.java_server.models.battle.Battle;
import xyz.qruto.java_server.models.battle.BattleField;
import xyz.qruto.java_server.models.units.Unit;
import xyz.qruto.java_server.models.units.UnitsConst;
import xyz.qruto.java_server.repositories.MovementRepository;
import xyz.qruto.java_server.services.SettingsService;
import xyz.qruto.java_server.services.SettlementService;
import xyz.qruto.java_server.utils.ArrivalTimeCalculator;

import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@EqualsAndHashCode(callSuper = true)
@Data
public class AttackMissionStrategy extends MissionStrategy {

    public AttackMissionStrategy(SettlementService settlementService,
                                 SettingsService settingsService,
                                 MovementRepository movementRepository,
                                 Movement movement) {
        super(settlementService, settingsService, movementRepository, movement);
    }

    @Override
    public void handle() {
        System.out.println("Attack has been handled");
        executeBattle();
    }

    private void executeBattle() {
        var battle = new Battle();
        List<Army> sidesArmy = new ArrayList<>();

        SettlementEntity offenseSettlement = settlementService.recalculateSettlement(
                movement.getFrom().getVillageId(),
                movement.getWhen());
        SettlementEntity defenseSettlement = settlementService.recalculateSettlement(
                movement.getTo().getVillageId(),
                movement.getWhen());

        var battleField = BattleField.builder()
                .tribe(defenseSettlement.getNation().ordinal())
                .population(100)
                .build();

        var off = Army.builder()
                .side(Army.ESide.OFF)
                .population(100)
                .units(UnitsConst.UNITS.get(offenseSettlement.getNation().ordinal()))
                .numbers(movement.getUnits())
                .mission(movement.getMission())
                .build();

        var ownDef = Army.builder()
                .side(Army.ESide.DEF)
                .population(100)
                .units(UnitsConst.UNITS.get(defenseSettlement.getNation().ordinal()))
                .numbers(defenseSettlement.getArmy())
                .build();

        List<Movement> reinforcementEntities = movementRepository
                .getAllByToVillageIdAndMovingIsFalse(defenseSettlement.getId());

        var reinforcementArmies = reinforcementEntities.stream()
                .map(g -> Army.builder()
                        .side(Army.ESide.DEF)
                        .population(100)
                        .units(UnitsConst.UNITS.get(g.getNation().ordinal()))
                        .numbers(g.getUnits())
                        .build()).toList();

        //defenders
        sidesArmy.add(ownDef);
        sidesArmy.addAll(reinforcementArmies);
        //attacker
        sidesArmy.add(off);

        var battleResults = battle.perform(battleField, sidesArmy);
        var plunder = returnOff(off, offenseSettlement, defenseSettlement);
        sidesArmy.remove(sidesArmy.size() - 1);
        updateDef(defenseSettlement, sidesArmy, reinforcementEntities);
        settlementService.save(defenseSettlement);
        //createReports(offenseSettlement, reinforcementEntities, battleResults.get(0), plunder);
    }

    private List<BigDecimal> returnOff(Army offArmy, SettlementEntity off, SettlementEntity def) {
        //off has been completely destroyed
        if (offArmy.getNumbers().stream().reduce(0, Integer::sum) == 0){
            movementRepository.deleteById(movement.getId());
            return Arrays.asList(BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO);
        }
        List<BigDecimal> plunder = calculatePlunder(offArmy.getNumbers(), def);
        def.spendResources(plunder);

        LocalDateTime whenBack = ArrivalTimeCalculator.getArrivalTime(off.getX(), off.getY(),
                def.getX(), def.getY(), offArmy.getNumbers(), settingsService.readSettings());
        var backMovement = Movement.builder()
                .id(movement.getId())
                .moving(true)
                .from(movement.getTo())
                .to(movement.getFrom())
                .when(whenBack)
                .units(offArmy.getNumbers())
                .plunder(plunder.stream().map(BigDecimal::intValue).toList())
                .mission(Mission.back)
                .nation(movement.getNation())
                .build();

        movementRepository.save(backMovement);

        return plunder;
    }

    private void updateDef(SettlementEntity def, List<Army> sidesArmy, List<Movement> defEntities) {
        def.setArmy(sidesArmy.get(0).getNumbers());
        // start from 1 because there is off army on the front in sidesArmy
        for (int i = 1; i < sidesArmy.size(); i++){
            var currentDef = defEntities.get(i - 1);
            if (sidesArmy.get(i).getNumbers().stream().reduce(0, Integer::sum) == 0){
                movementRepository.deleteById(currentDef.getId());
                continue;
            }
            currentDef.setUnits(sidesArmy.get(i).getNumbers());
            movementRepository.save(currentDef);
        }
    }

    private List<BigDecimal> calculatePlunder(List<Integer> units, SettlementEntity defenseSettlement) {
        var storage = defenseSettlement.getStorage();
        var availableResources = storage.stream()
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        var resPercents = storage.stream()
                .map(res -> BigDecimal
                        .valueOf(100).multiply(res).divide(availableResources, MathContext.DECIMAL32))
                .toList();
        var carry = Math.min(calculateCarry(units), availableResources.intValue());

        var wood = resPercents.get(0).divide(BigDecimal.valueOf(100), MathContext.DECIMAL32)
                .multiply(BigDecimal.valueOf(carry)).setScale(0, RoundingMode.HALF_DOWN);
        var clay = resPercents.get(1).divide(BigDecimal.valueOf(100), MathContext.DECIMAL32)
                .multiply(BigDecimal.valueOf(carry)).setScale(0, RoundingMode.HALF_DOWN);
        var iron = resPercents.get(2).divide(BigDecimal.valueOf(100), MathContext.DECIMAL32)
                .multiply(BigDecimal.valueOf(carry)).setScale(0, RoundingMode.HALF_DOWN);
        var crop = resPercents.get(3).divide(BigDecimal.valueOf(100), MathContext.DECIMAL32)
                .multiply(BigDecimal.valueOf(carry)).setScale(0, RoundingMode.HALF_DOWN);

        return Arrays.asList(wood, clay, iron, crop);
    }

    /*private void createReports(SettlementEntity attacker,
                               List<CombatGroupEntity> reinforcement,
                               BattleResult battleResult,
                               List<BigDecimal> plunder) {
        var battleField = state.getSettlementEntity();
        int carry = calculateCarry();
        List<ReportPlayerEntity> defenders = new ArrayList<>();
        //own def
        defenders.add(ReportPlayerEntity.builder()
                .settlementId(battleField.getId())
                .nation(battleField.getNation())
                .troops(battleResult.getUnitsBeforeBattle().get(0))
                .dead(battleResult.getCasualties().get(0))
                .build());
        for (int i = 0; i < reinforcement.size(); i++){
            var current = reinforcement.get(i);
            defenders.add(ReportPlayerEntity.builder()
                    .settlementId(current.getFromSettlementId())
                    .nation(current.getOwnerNation())
                    .troops(battleResult.getUnitsBeforeBattle().get(i + 1))
                    .dead(battleResult.getCasualties().get(i + 1))
                    .build());
        }
        var report = new ReportEntity(
                attacker.getAccountId(),
                combatGroup.getMission(),
                ReportPlayerEntity.builder()
                        //here is to instead of from because swap was apply in the returnOff method
                        .settlementId(combatGroup.getFromSettlementId())
                        .nation(combatGroup.getOwnerNation())
                        .troops(battleResult.getUnitsBeforeBattle().get(battleResult.getUnitsBeforeBattle().size() - 1))
                        .dead(battleResult.getCasualties().get(battleResult.getCasualties().size() - 1))
                        .bounty(plunder)
                        .carry(carry)
                        .build(),
                defenders, combatGroup.getExecutionTime());
        var repo = engineService.getReportRepository();
        repo.save(report);
        report.setReportOwner(battleField.getAccountId());
        report.setId(null);
        repo.save(report);
    }*/

    private int calculateCarry(List<Integer> units) {
        List<Unit> template = UnitsConst.UNITS.get(movement.getNation().ordinal());
        var carry = 0;
        for (var i = 0; i < units.size(); i++) {
            carry += units.get(i) * template.get(i).getCapacity();
        }
        return carry;
    }
}
