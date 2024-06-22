package xyz.qruto.java_server.services;

import org.springframework.data.domain.Page;
import xyz.qruto.java_server.entities.StatisticsEntity;
import xyz.qruto.java_server.models.responses.StatisticsResponse;

public interface StatisticsService {

    Page<StatisticsEntity> getStatisticsSortedAndPaginated(int page, int size, String sortBy, boolean ascending);

    StatisticsResponse getStatistics(String userId, String sortBy, boolean ascending, int pageSize, int page);

    StatisticsEntity getByUserId(String userId);

    StatisticsEntity save(StatisticsEntity statistics);

}
