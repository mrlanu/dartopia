package xyz.qruto.java_server;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import xyz.qruto.java_server.entities.SettlementEntity;
import xyz.qruto.java_server.models.Nations;
import xyz.qruto.java_server.models.SettlementKind;
import xyz.qruto.java_server.models.executables.ConstructionTask;
import xyz.qruto.java_server.models.executables.EmptyTask;
import xyz.qruto.java_server.models.units.CombatUnitQueue;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Arrays;

import static org.assertj.core.api.Assertions.assertThat;

public class SettlementEntityTest {

    private SettlementEntity settlementEntity;

    @BeforeEach
    public void setUp() {
        settlementEntity = SettlementEntity.builder()
                .userId("SerhiyId")
                .name("New Settlement")
                .nation(Nations.gaul)
                .settlementKind(SettlementKind.six)
                .x(10)
                .y(10)
                .storage(Arrays.asList(BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO))
                .buildings(Arrays.asList(
                        Arrays.asList(0, 0, 3, 0), Arrays.asList(1, 1, 3, 0),
                        Arrays.asList(2, 2, 3, 0), Arrays.asList(3, 3, 3, 0),
                        Arrays.asList(4, 3, 1, 0)))
                .units(Arrays.asList(0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
                .constructionTasks(new ArrayList<>())
                .combatUnitQueue(new ArrayList<>())
                .lastModified(LocalDateTime.now().minusHours(1))
                .build();
    }

    @Test
    public void testCalculateProducePerHour() {
        var result = settlementEntity.calculateProducePerHour();
        assertThat(result.get(0)).isEqualTo(15);
        assertThat(result.get(1)).isEqualTo(15);
        assertThat(result.get(2)).isEqualTo(15);
        assertThat(result.get(3)).isEqualTo(20);
    }

    @Test
    public void testLastTimeModifiedUpdated() {
        LocalDateTime untilTime = LocalDateTime.now();
        settlementEntity.update(untilTime);
        assertThat(settlementEntity.getLastModified().truncatedTo(ChronoUnit.SECONDS))
                .isEqualTo(LocalDateTime.now().truncatedTo(ChronoUnit.SECONDS));
    }

    @Test
    public void testUpdate_withNoEvents() {
        LocalDateTime untilTime = LocalDateTime.now();
        settlementEntity.update(untilTime);

        assertThat(settlementEntity.getStorage().get(0))
                .isEqualTo(BigDecimal.valueOf(15));
        assertThat(settlementEntity.getStorage().get(1))
                .isEqualTo(BigDecimal.valueOf(15));
        assertThat(settlementEntity.getStorage().get(2))
                .isEqualTo(BigDecimal.valueOf(15));
        assertThat(settlementEntity.getStorage().get(3))
                .isEqualTo(BigDecimal.valueOf(20));
    }

    @Test
    public void testUpdate_withConstructionTask() {
        LocalDateTime untilTime = LocalDateTime.now();

        settlementEntity.getConstructionTasks().add(
                new ConstructionTask("1", 0, 0, 1,
                        LocalDateTime.now().minusMinutes(30)));

        settlementEntity.getConstructionTasks().add(
                new ConstructionTask("2", 1, 1, 1,
                        LocalDateTime.now().minusMinutes(15)));

        settlementEntity.update(untilTime);

        assertThat(settlementEntity.getStorage().get(0))
                .isEqualTo(BigDecimal.valueOf(18.5).setScale(3, RoundingMode.HALF_UP));
        assertThat(settlementEntity.getStorage().get(1))
                .isEqualTo(BigDecimal.valueOf(16.75).setScale(3, RoundingMode.HALF_UP));
        assertThat(settlementEntity.getStorage().get(2))
                .isEqualTo(BigDecimal.valueOf(15.0).setScale(3, RoundingMode.HALF_UP));
        assertThat(settlementEntity.getStorage().get(3))
                .isEqualTo(BigDecimal.valueOf(20.0).setScale(3, RoundingMode.HALF_UP));
    }

    @Test
    public void testCastStorage_storageHasToBeCast() {
        LocalDateTime untilTime = LocalDateTime.now().plusDays(3);
        settlementEntity.update(untilTime);
        assertThat(settlementEntity.getStorage().get(0)).isEqualTo(BigDecimal.valueOf(800));
        assertThat(settlementEntity.getStorage().get(3)).isEqualTo(BigDecimal.valueOf(800));
    }

    @Test
    public void testGetReadyUnits() {
        LocalDateTime untilTime = LocalDateTime.now().plusSeconds(31);
        settlementEntity.getCombatUnitQueue()
                .add(new CombatUnitQueue("1", LocalDateTime.now().minusMinutes(5),
                        0, 5, 60));
        settlementEntity.getCombatUnitQueue()
                .add(new CombatUnitQueue("2", LocalDateTime.now(),
                        0, 5, 60));

        assertThat(settlementEntity.getCombatUnitQueue().size()).isEqualTo(2);

        var result = settlementEntity.getReadyUnits(untilTime);

        assertThat(result.size()).isEqualTo(5);
        assertThat(settlementEntity.getCombatUnitQueue().size()).isEqualTo(1);

        LocalDateTime untilTime2 = LocalDateTime.now().plusSeconds(60);
        var result2 = settlementEntity.getReadyUnits(untilTime2);

        assertThat(result2.size()).isEqualTo(1);
        assertThat(settlementEntity.getCombatUnitQueue().size()).isEqualTo(1);
    }

    @Test
    public void testUnitsProductions() {
        LocalDateTime untilTime = LocalDateTime.now().plusSeconds(31);
        settlementEntity.getCombatUnitQueue()
                .add(new CombatUnitQueue("1", LocalDateTime.now().minusMinutes(5),
                        0, 5, 60));

        settlementEntity.update(untilTime);

        assertThat(settlementEntity.getUnits().get(0)).isEqualTo(5);
    }

    @Test
    public void testCalculateEatPerHour() {
        settlementEntity.setUnits(Arrays.asList(5, 0, 0, 10, 0, 0, 0, 0, 0, 0));

        var result = settlementEntity.calculateEatPerHour();

        assertThat(result).isEqualTo(25);
    }

    @ParameterizedTest
    @CsvSource({"60, 15","120, 0"})
    public void testCalculateEatenCrop(int units, int expected) {
        LocalDateTime untilTime = LocalDateTime.now().minusMinutes(45);
        settlementEntity.setUnits(Arrays.asList(units, 0, 0, 0, 0, 0, 0, 0, 0, 0));
        settlementEntity.getStorage().set(3, BigDecimal.valueOf(30));

        settlementEntity.calculateEatenCrop(untilTime);

        assertThat(settlementEntity.getStorage().get(3)).isEqualTo(BigDecimal.valueOf(expected)
                .setScale(2, RoundingMode.HALF_UP));
    }

    @Test
    public void testStarvation() {
        LocalDateTime untilTime = LocalDateTime.now();
        settlementEntity.setUnits(Arrays.asList(60, 0, 0, 0, 0, 0, 0, 0, 0, 0));
        settlementEntity.getStorage().set(3, BigDecimal.TEN);
        settlementEntity.update(untilTime);

        assertThat(settlementEntity.getUnits().get(0)).isEqualTo(58);
    }

    @Test
    public void testCombineAllEvents() {
        LocalDateTime untilTime = LocalDateTime.now();

        settlementEntity.getConstructionTasks().add(
                new ConstructionTask("1", 0, 0, 1,
                        LocalDateTime.now().minusMinutes(30)));

        settlementEntity.getCombatUnitQueue()
                .add(new CombatUnitQueue("1", LocalDateTime.now().minusMinutes(35),
                        0, 10, 60));

        var result = settlementEntity.combineAllEvents(untilTime);

        assertThat(result.size()).isEqualTo(12);
        assertThat(result.get(4)).isInstanceOf(ConstructionTask.class);
        assertThat(result.get(11)).isInstanceOf(EmptyTask.class);
    }

}

