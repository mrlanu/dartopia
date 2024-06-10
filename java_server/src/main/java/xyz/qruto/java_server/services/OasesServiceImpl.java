package xyz.qruto.java_server.services;

import org.springframework.stereotype.Service;
import xyz.qruto.java_server.entities.SettlementEntity;
import xyz.qruto.java_server.models.Nations;
import xyz.qruto.java_server.models.SettlementKind;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

@Service
public class OasesServiceImpl implements OasesService {
    private final SettingsService  settingsService;

    public OasesServiceImpl(SettingsService settingsService) {
        this.settingsService = settingsService;
    }

    @Override
    public SettlementEntity getOasis(String userId, SettlementKind kind, int x, int y) {
        return SettlementEntity.builder()
                .userId(userId)
                .name(settingsService.readSettings().getOasisName())
                .nation(Nations.nature)
                .kind(kind)
                .x(x)
                .y(y)
                .storage(Arrays.asList(BigDecimal.valueOf(500), BigDecimal.valueOf(500), BigDecimal.valueOf(500), BigDecimal.valueOf(500)))
                .buildings(Arrays.asList(
                        Arrays.asList(0, 0, 10, 0), Arrays.asList(1, 1, 10, 0),
                        Arrays.asList(2, 2, 10, 0), Arrays.asList(3, 3, 10, 0)))
                .army(Arrays.asList(0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
                .availableUnits(new ArrayList<>())
                .constructionTasks(new ArrayList<>())
                .combatUnitQueue(new ArrayList<>())
                .movements(new ArrayList<>())
                .lastModified(LocalDateTime.now())
                .lastSpawnedAnimals(LocalDateTime.now())
                .build();
    }

    @Override
    public void spawnAnimals(SettlementEntity settlement) {
        var isTimeSpawnAnimals = settlement.getLastSpawnedAnimals()
                .isBefore(LocalDateTime.now()
                        .minusMinutes(settingsService.readSettings().getNatureRegTime()));
        if (isTimeSpawnAnimals) {
            calculateSpawnedUnits(settlement.getKind(), settlement.getArmy());
            settlement.setLastSpawnedAnimals(LocalDateTime.now());
        }
    }

    public void calculateSpawnedUnits(SettlementKind kind, List<Integer> units) {
        switch (kind) {
            case w:
                if (shouldSpawn(units, 4, 5, 6)) {
                    units.set(4, units.get(4) + getRandom(15) + 5);
                    units.set(5, units.get(5) + getRandom(5));
                    units.set(6, units.get(6) + getRandom(5));
                }
                break;
            case w_cr:
                if (shouldSpawn(units, 4, 5, 6, 7, 8)) {
                    units.set(4, units.get(4) + getRandom(15) + 5);
                    units.set(5, units.get(5) + getRandom(5));
                    units.set(6, units.get(6) + getRandom(5));
                    units.set(7, units.get(7) + getRandom(5));
                    units.set(8, units.get(8) + getRandom(3));
                }
                break;
            case c, i:
                if (shouldSpawn(units, 0, 1, 4)) {
                    units.set(0, units.get(0) + getRandom(15) + 10);
                    units.set(1, units.get(1) + getRandom(15) + 5);
                    units.set(4, units.get(4) + getRandom(10));
                }
                break;
            case c_cr:
                if (shouldSpawn(units, 0, 1, 4, 9)) {
                    units.set(0, units.get(0) + getRandom(20) + 15);
                    units.set(1, units.get(1) + getRandom(15) + 10);
                    units.set(4, units.get(4) + getRandom(10));
                    units.set(9, units.get(9) + getRandom(3));
                }
                break;
            case i_cr:
                if (shouldSpawn(units, 0, 1, 4, 8)) {
                    units.set(0, units.get(0) + getRandom(20) + 15);
                    units.set(1, units.get(1) + getRandom(15) + 10);
                    units.set(4, units.get(4) + getRandom(10));
                    units.set(8, units.get(8) + getRandom(3));
                }
                break;
            case cr:
                if (shouldSpawn(units, 0, 2, 6, 7, 8)) {
                    units.set(0, units.get(0) + getRandom(15) + 5);
                    units.set(2, units.get(2) + getRandom(10) + 5);
                    units.set(6, units.get(6) + getRandom(10));
                    units.set(7, units.get(7) + getRandom(5));
                    units.set(8, units.get(8) + getRandom(5));
                }
                break;
            case cr_cr:
                if (shouldSpawn(units, 0, 2, 6, 7, 8, 9)) {
                    units.set(0, units.get(0) + getRandom(15) + 10);
                    units.set(2, units.get(2) + getRandom(10) + 5);
                    units.set(6, units.get(6) + getRandom(10));
                    units.set(7, units.get(7) + getRandom(5));
                    units.set(8, units.get(8) + getRandom(5));
                    units.set(9, units.get(9) + getRandom(3));
                }
                break;
            default:
                throw new UnsupportedOperationException("SettlementKind not supported");
        }
    }

    private static boolean shouldSpawn(List<Integer> units, int... indices) {
        final int MIN_UNITS_FOR_OASIS = 15;
        final int MAX_UNITS_FOR_OASIS = 30;

        for (int index : indices) {
            if (units.get(index) <= MIN_UNITS_FOR_OASIS + getRandom(MAX_UNITS_FOR_OASIS)) {
                return true;
            }
        }
        return false;
    }

    private static int getRandom(int bound) {
        Random random = new Random();
        return random.nextInt(bound + 1);
    }
}
