package xyz.qruto.java_server.services;

import org.springframework.stereotype.Service;
import xyz.qruto.java_server.entities.MapTile;
import xyz.qruto.java_server.entities.SettlementEntity;
import xyz.qruto.java_server.entities.UserEntity;
import xyz.qruto.java_server.models.SettlementKind;
import xyz.qruto.java_server.models.TileProbability;
import xyz.qruto.java_server.models.responses.TileDetails;
import xyz.qruto.java_server.repositories.SettlementRepository;
import xyz.qruto.java_server.repositories.UserRepository;
import xyz.qruto.java_server.repositories.WorldRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import static xyz.qruto.java_server.models.SettlementKind.proportions;

@Service
public class WorldServiceImpl implements WorldService{

    private final UserRepository userRepository;
    private final SettingsService settingsService;
    private final WorldRepository worldRepository;
    private final SettlementRepository settlementRepository;
    private final OasesService oasesService;

    public WorldServiceImpl(UserRepository userRepository,
                            SettingsService settingsService,
                            WorldRepository worldRepository,
                            SettlementRepository settlementRepository, OasesService oasesService) {
        this.userRepository = userRepository;
        this.settingsService = settingsService;
        this.worldRepository = worldRepository;
        this.settlementRepository = settlementRepository;
        this.oasesService = oasesService;
    }

    @Override
    public MapTile save(MapTile mapTile){
        return worldRepository.save(mapTile);
    }

    @Override
    public void createWorld() {
        dropWorld();
        var natureUser = createUserNature();
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
                    SettlementEntity oasis = oasesService.getOasis(natureUser.getId(), selectedTile.kind(), x, y);
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

    @Override
    public MapTile findEmptyTile() {
        MapTile tile;
        while (true){
            int x = getRandomIntInRange();
            int y = getRandomIntInRange();
            tile = worldRepository.getByCorXAndCorY(x, y);
            if (tile.getName().equals("Gras land")) {
                return tile;
            }
        }
    }

    @Override
    public TileDetails getTileByCoordinates(int x, int y){
        var settlement = settlementRepository.findByXAndY(x, y).orElseThrow();
        var user = userRepository.findById(settlement.getUserId()).orElseThrow();
        if(settlement.getKind().isOasis()){
            oasesService.spawnAnimals(settlement);
            settlementRepository.save(settlement);
        }
        return TileDetails.builder()
                .id(settlement.getId())
                .playerName(user.getName())
                .name(settlement.getName())
                .x(settlement.getX())
                .y(settlement.getY())
                .population(100)
                .animals(settlement.getKind().isOasis() ? settlement.getArmy() : null)
                .distance(3)
                .build();
    }

    private int getRandomIntInRange() {
        Random random = new Random();
        var min = 4;
        var max = settingsService.readSettings().getMapWidth() - 3;
        return random.nextInt((max - min) + 1) + min;
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

    private void dropWorld() {
        worldRepository.deleteAll();
        settlementRepository.deleteAll();
        userRepository.deleteAll();
    }

    private UserEntity createUserNature() {
        return userRepository.save(
                new UserEntity("nature", "nature@nature.com", "123"));
    }
}
