package xyz.qruto.java_server.services;

import org.springframework.stereotype.Service;
import xyz.qruto.java_server.entities.MapTile;
import xyz.qruto.java_server.models.MapTileFactory;
import xyz.qruto.java_server.models.MapTiles;
import xyz.qruto.java_server.models.TileProbability;
import xyz.qruto.java_server.repositories.WorldRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import static xyz.qruto.java_server.models.MapTileFactory.proportions;

@Service
public class WorldServiceImpl implements WorldService{

    private final SettingsService settingsService;
    private final WorldRepository worldRepository;

    public WorldServiceImpl(SettingsService settingsService, WorldRepository worldRepository) {
        this.settingsService = settingsService;
        this.worldRepository = worldRepository;
    }

    @Override
    public void createWorld() {
        Random random = new Random();
        var settings = settingsService.readSettings();
        List<Double> cumulativeProbability = getCumulativeProbability();
        List<MapTile> world = new ArrayList<>();

        for (int y = settings.getMapHeight(); y > 0; y--) {
            for (int x = 1; x <= settings.getMapWidth(); x++) {
                if(y < 4 || y > settings.getMapHeight() - 3
                        || x < 4 || x > settings.getMapWidth() - 3) {
                    world.add(MapTileFactory.getTile(MapTiles.water, x, y));
                    continue;
                }
                double randValue = random.nextDouble();
                TileProbability selectedTile = selectTileByProbability(randValue, cumulativeProbability);
                world.add(MapTileFactory.getTile(selectedTile.name(), x, y));
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

    private int getIndexByXY(int x, int y) {
        return y * settingsService.readSettings().getMapWidth() + x;
    }
}
