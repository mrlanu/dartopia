package xyz.qruto.java_server.services;

import org.springframework.stereotype.Service;
import xyz.qruto.java_server.entities.SettlementEntity;
import xyz.qruto.java_server.models.Nations;
import xyz.qruto.java_server.models.SettlementKind;
import xyz.qruto.java_server.repositories.SettlementRepository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;

@Service
public class SettlementServiceImpl implements SettlementService{

    private final SettlementRepository settlementRepository;

    public SettlementServiceImpl(SettlementRepository settlementRepository) {
        this.settlementRepository = settlementRepository;
    }

    public SettlementEntity createMockSettlement() {
        var settlementEntity = SettlementEntity.builder()
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
        return settlementRepository.save(settlementEntity);
    }

    @Override
    public SettlementEntity getMockSettlement(String settlementId) {
        var settlement = settlementRepository.findById(settlementId)
                .orElseThrow(() -> new IllegalArgumentException("Settlement not found"));
        settlement.update(LocalDateTime.now());
        return settlementRepository.save(settlement);
    }
}
