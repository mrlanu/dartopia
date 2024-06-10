package xyz.qruto.java_server.services;

import org.springframework.stereotype.Service;
import xyz.qruto.java_server.entities.MapTile;
import xyz.qruto.java_server.entities.SettlementEntity;
import xyz.qruto.java_server.entities.UserEntity;
import xyz.qruto.java_server.models.*;
import xyz.qruto.java_server.models.responses.TileDetails;
import xyz.qruto.java_server.repositories.SettlementRepository;
import xyz.qruto.java_server.repositories.UserRepository;
import xyz.qruto.java_server.repositories.WorldRepository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;

import static xyz.qruto.java_server.models.SettlementKind.proportions;

@Service
public class WorldServiceImpl implements WorldService{

    private final UserRepository userRepository;
    private final SettingsService settingsService;
    private final WorldRepository worldRepository;
    private final SettlementRepository settlementRepository;

    public WorldServiceImpl(UserRepository userRepository,
                            SettingsService settingsService,
                            WorldRepository worldRepository,
                            SettlementRepository settlementRepository) {
        this.userRepository = userRepository;
        this.settingsService = settingsService;
        this.worldRepository = worldRepository;
        this.settlementRepository = settlementRepository;
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
                    SettlementEntity oasis = getOasis(natureUser.getId(), selectedTile.kind(), x, y);
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
        var settlement = settlementRepository.findByXAndY(x, y);
        var user = userRepository.findById(settlement.getUserId()).orElseThrow();
        if(settlement.getKind().isOasis()){
            spawnAnimals(settlement);
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

    private void spawnAnimals(SettlementEntity settlement) {
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
            case c:
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
            case i:
                if (shouldSpawn(units, 0, 1, 4)) {
                    units.set(0, units.get(0) + getRandom(15) + 10);
                    units.set(1, units.get(1) + getRandom(15) + 5);
                    units.set(4, units.get(4) + getRandom(10));
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

    private SettlementEntity getOasis(String userId, SettlementKind kind, int x, int y) {
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
