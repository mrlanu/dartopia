package xyz.qruto.java_server.services;

import xyz.qruto.java_server.entities.SettlementEntity;
import xyz.qruto.java_server.models.requests.ConstructionRequest;
import xyz.qruto.java_server.models.requests.SendTroopsRequest;
import xyz.qruto.java_server.models.requests.TroopsSendContract;
import xyz.qruto.java_server.models.responses.ShortSettlementInfo;

import java.time.LocalDateTime;
import java.util.List;

public interface SettlementService {
    SettlementEntity getSettlementById(String settlementId, LocalDateTime untilTime);

    SettlementEntity recalculateSettlement(String settlementId, LocalDateTime untilTime);

    List<ShortSettlementInfo> getAllSettlementsByUserId(String userId);

    SettlementEntity addConstructionTask(String settlementId,
                                         ConstructionRequest constructionRequest);

    TroopsSendContract updateContract(String fromSettlementId, TroopsSendContract troopsSendContract);

    String sendUnits(String fromSettlementId, SendTroopsRequest request);

    SettlementEntity save(SettlementEntity defenseSettlement);
}
