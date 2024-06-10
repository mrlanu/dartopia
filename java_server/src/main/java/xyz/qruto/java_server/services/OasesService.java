package xyz.qruto.java_server.services;

import xyz.qruto.java_server.entities.SettlementEntity;
import xyz.qruto.java_server.models.SettlementKind;

public interface OasesService {
    SettlementEntity getOasis(String userId, SettlementKind kind, int x, int y);

    void spawnAnimals(SettlementEntity settlement);
}
