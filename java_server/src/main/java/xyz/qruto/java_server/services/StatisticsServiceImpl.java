package xyz.qruto.java_server.services;

import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import xyz.qruto.java_server.entities.StatisticsEntity;
import xyz.qruto.java_server.models.responses.StatisticsResponse;
import xyz.qruto.java_server.repositories.StatisticsRepository;

import java.util.List;
import java.util.stream.IntStream;

@Service
public class StatisticsServiceImpl implements StatisticsService {

    private final StatisticsRepository statisticsRepository;

    public StatisticsServiceImpl(StatisticsRepository repository) {
        this.statisticsRepository = repository;
    }


    //not used, just for reference
    @Override
    public Page<StatisticsEntity> getStatisticsSortedAndPaginated(int page, int size, String sortBy, boolean ascending) {
        Sort sort = Sort.by(ascending ? Sort.Direction.ASC : Sort.Direction.DESC, sortBy);
        Pageable pageable = PageRequest.of(page, size, sort);
        Page<StatisticsEntity> pagedResult = statisticsRepository.findAll(pageable);

        List<StatisticsEntity> dtoList = IntStream.range(0, pagedResult.getContent().size())
                .mapToObj(i -> {
                    StatisticsEntity statisticsOld = pagedResult.getContent().get(i);
                    return StatisticsEntity.builder()
                            .id(statisticsOld.getId())
                            .position(i + page * size)
                            .playerName(statisticsOld.getPlayerName())
                            .playerId(statisticsOld.getPlayerId())
                            .population(statisticsOld.getPopulation())
                            .villagesCount(statisticsOld.getVillagesCount())
                            .allianceName(statisticsOld.getAllianceName())
                            .attackPoints(statisticsOld.getAttackPoints())
                            .defensePoints(statisticsOld.getDefensePoints())
                            .build();
                }).toList();

        return new PageImpl<>(dtoList, pageable, pagedResult.getTotalElements());
    }

    @Override
    public StatisticsResponse getStatistics(String userId, String sortBy, boolean ascending, int pageSize, int pageNumber) {
        Sort sort = Sort.by(ascending ? Sort.Direction.ASC : Sort.Direction.DESC, sortBy);
        if (pageNumber < 0) {
            List<StatisticsEntity> sortedList = statisticsRepository.findAll(sort);
            StatisticsEntity targetEntity = statisticsRepository.findByPlayerId(userId).orElseThrow();
            int index = sortedList.indexOf(targetEntity);
            pageNumber = (int) Math.ceil((double) index / pageSize);
        }

        Pageable pageable = PageRequest.of(pageNumber - 1, pageSize, sort);
        Page<StatisticsEntity> pagedResult = statisticsRepository.findAll(pageable);

        int finalPageNumber = pageNumber;
        List<StatisticsEntity> indexedStatistics = IntStream.range(0, pagedResult.getContent().size())
                .mapToObj(i -> {
                    StatisticsEntity statisticsOld = pagedResult.getContent().get(i);
                    return StatisticsEntity.builder()
                            .id(statisticsOld.getId())
                            .position(i + finalPageNumber * pageSize)
                            .playerName(statisticsOld.getPlayerName())
                            .playerId(statisticsOld.getPlayerId())
                            .population(statisticsOld.getPopulation())
                            .villagesCount(statisticsOld.getVillagesCount())
                            .allianceName(statisticsOld.getAllianceName())
                            .attackPoints(statisticsOld.getAttackPoints())
                            .defensePoints(statisticsOld.getDefensePoints())
                            .build();
                }).toList();

        return StatisticsResponse.builder()
                .modelsList(indexedStatistics)
                .currentPage(pageNumber)
                .totalItems((int) pagedResult.getTotalElements())
                .totalPages((int) Math.ceil((double) pagedResult.getTotalElements()
                        / pagedResult.getPageable().getPageSize()))
                .itemsPerPage(pageSize)
                .build();
    }

    @Override
    public StatisticsEntity getByUserId(String userId) {
        return statisticsRepository.findByPlayerId(userId).orElseThrow();
    }

    @Override
    public StatisticsEntity save(StatisticsEntity statistics) {
        return statisticsRepository.save(statistics);
    }
}
