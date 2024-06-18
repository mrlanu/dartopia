package xyz.qruto.java_server.models.responses;

import lombok.Builder;
import lombok.Data;
import xyz.qruto.java_server.entities.StatisticsEntity;

import java.util.List;

@Data
@Builder
public class StatisticsResponse {
    private List<StatisticsEntity> modelsList;
    private int currentPage;
    private int totalItems;
    private int totalPages;
    private int itemsPerPage;
}
