package xyz.qruto.java_server.services;

import xyz.qruto.java_server.entities.SettlementEntity;
import xyz.qruto.java_server.models.responses.ShortSettlementInfo;

import java.util.List;

public interface SettlementService {
    SettlementEntity createMockSettlement();
    SettlementEntity getSettlementById(String settlementId);
    List<ShortSettlementInfo> getAllSettlementsByUserId(String userId);
}
