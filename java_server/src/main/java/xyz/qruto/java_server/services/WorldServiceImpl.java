package xyz.qruto.java_server.services;

import org.springframework.stereotype.Service;
import xyz.qruto.java_server.entities.MapTile;
import xyz.qruto.java_server.repositories.WorldRepository;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

@Service
public class WorldServiceImpl implements WorldService{

    private final WorldRepository worldRepository;
    private static final List<TileProbability> proportions = Arrays.asList(
            new TileProbability(0, 0.84),
            new TileProbability(3, 0.02),
            new TileProbability(5, 0.02),
            new TileProbability(17, 0.02),
            new TileProbability(19, 0.02),
            new TileProbability(27, 0.02),
            new TileProbability(29, 0.02),
            new TileProbability(41, 0.02),
            new TileProbability(43, 0.02)

    );

    public WorldServiceImpl(WorldRepository worldRepository) {
        this.worldRepository = worldRepository;
    }

    @Override
    public void createWorld() {
        Random random = new Random();
        List<Double> cumulativeProbability = getCumulativeProbability();
        List<MapTile> world = new ArrayList<>();

        for (int y = 49; y >= 0; y--) {
            for (int x = 0; x < 50; x++) {
                if(y < 4 || y > 46 || x < 4 || x > 46) {
                    world.add(MapTile.builder()
                            .corX(x)
                            .corY(y)
                            .name("Water")
                            .tileNumber(89)
                            .build());
                    continue;
                }
                double randValue = random.nextDouble();
                TileProbability selectedTile = selectTileByProbability(randValue, cumulativeProbability);
                world.add(
                        MapTile.builder()
                                .corX(x)
                                .corY(y)
                                .name(selectedTile.tileCode == 0 ? "Grass land" : "Oasis")
                                .tileNumber(selectedTile.tileCode)
                                .build()
                );
            }
        }
        worldRepository.deleteAll();
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
            cumulativeSum += proportion.probability;
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

    private record TileProbability(int tileCode, double probability){}
}
