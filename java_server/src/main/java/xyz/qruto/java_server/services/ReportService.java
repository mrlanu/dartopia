package xyz.qruto.java_server.services;

import xyz.qruto.java_server.entities.Movement;
import xyz.qruto.java_server.entities.SettlementEntity;
import xyz.qruto.java_server.models.battle.BattleResult;
import xyz.qruto.java_server.models.responses.MilitaryReportResponse;
import xyz.qruto.java_server.models.responses.UnreadAmountAndBriefs;

import java.util.List;

public interface ReportService {
    void createReports(Movement movement,
                       SettlementEntity attacker,
                       SettlementEntity defender,
                       List<Movement> reinforcement,
                       BattleResult battleResult,
                       List<Integer> plunder);

    UnreadAmountAndBriefs createReportsBrief(String playerId);

    MilitaryReportResponse fetchReportById(String reportId, String playerId);

    void deleteById(String id, String userId);
}
