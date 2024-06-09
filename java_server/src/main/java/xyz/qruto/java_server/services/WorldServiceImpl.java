package xyz.qruto.java_server.services;

import org.springframework.stereotype.Service;
import xyz.qruto.java_server.entities.MapTile;
import xyz.qruto.java_server.entities.SettlementEntity;
import xyz.qruto.java_server.models.*;
import xyz.qruto.java_server.repositories.SettlementRepository;
import xyz.qruto.java_server.repositories.WorldRepository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

import static xyz.qruto.java_server.models.SettlementKind.proportions;

@Service
public class WorldServiceImpl implements WorldService{

    private final SettingsService settingsService;
    private final WorldRepository worldRepository;
    private final SettlementRepository settlementRepository;

    public WorldServiceImpl(SettingsService settingsService,
                            WorldRepository worldRepository,
                            SettlementRepository settlementRepository) {
        this.settingsService = settingsService;
        this.worldRepository = worldRepository;
        this.settlementRepository = settlementRepository;
    }

    @Override
    public void createWorld() {
        worldRepository.deleteAll();
        settlementRepository.deleteAll();
        Random random = new Random();
        var settings = settingsService.readSettings();
        List<Double> cumulativeProbability = getCumulativeProbability();
        List<MapTile> world = new ArrayList<>();
        List<SettlementEntity> settlements = new ArrayList<>();

        for (int y = settings.getMapHeight(); y > 0; y--) {
            for (int x = 1; x <= settings.getMapWidth(); x++) {
                if(y < 4 || y > settings.getMapHeight() - 3
                        || x < 4 || x > settings.getMapWidth() - 3) {
                    world.add(SettlementKind.getTile(SettlementKind.water, x, y));
                    continue;
                }
                double randValue = random.nextDouble();
                TileProbability selectedTile = selectTileByProbability(randValue, cumulativeProbability);
                world.add(SettlementKind.getTile(selectedTile.kind(), x, y));

                if(!selectedTile.kind().equals(SettlementKind.gras_land)){
                    SettlementEntity oasis = getOasis(selectedTile.kind(), "nature", x, y);
                    settlements.add(oasis);
                }
            }
        }
        settlementRepository.saveAll(settlements);
        worldRepository.saveAll(world);
    }

    @Override
    public List<MapTile> getAllByCorXBetweenAndCorYBetween(int fromX, int toX, int fromY, int toY) {
        return worldRepository.getAllByCorXBetweenAndCorYBetween(fromX, toX, fromY, toY);
    }

    private List<Double> getCumulativeProbability() {
        double cumulativeSum = 0;
        List<Double> cumulativeProbability = new ArrayList<>();
        for (TileProbability proportion : proportions) {
            cumulativeSum += proportion.probability();
            cumulativeProbability.add(cumulativeSum);
        }
        return cumulativeProbability;
    }

    private TileProbability selectTileByProbability(double randValue, List<Double> cumulativeProportions) {
        for (int i = 0; i < cumulativeProportions.size(); i++) {
            if (randValue <= cumulativeProportions.get(i)) {
                return proportions.get(i);
            }
        }
        return proportions.get(proportions.size() - 1); // Fallback in case of rounding errors
    }

    private SettlementEntity getOasis(SettlementKind kind, String userId, int x, int y) {
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
}
