package xyz.qruto.java_server.services;

import xyz.qruto.java_server.entities.SettlementEntity;

public interface SettlementService {
    SettlementEntity createMockSettlement();
    SettlementEntity getMockSettlement(String settlementId);
}
