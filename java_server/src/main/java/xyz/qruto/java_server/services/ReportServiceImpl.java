package xyz.qruto.java_server.services;

import org.springframework.stereotype.Service;
import xyz.qruto.java_server.entities.Movement;
import xyz.qruto.java_server.entities.ReportEntity;
import xyz.qruto.java_server.entities.ReportOwner;
import xyz.qruto.java_server.entities.SettlementEntity;
import xyz.qruto.java_server.models.Mission;
import xyz.qruto.java_server.models.battle.BattleResult;
import xyz.qruto.java_server.models.responses.*;
import xyz.qruto.java_server.repositories.ReportRepository;
import xyz.qruto.java_server.repositories.SettlementRepository;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class ReportServiceImpl implements ReportService {

    private final ReportRepository reportRepository;
    private final SettlementRepository settlementRepository;

    public ReportServiceImpl(ReportRepository reportRepository, SettlementRepository settlementRepository) {
        this.reportRepository = reportRepository;
        this.settlementRepository = settlementRepository;
    }

    @Override
    public void createReports(Movement movement,
                              SettlementEntity attacker,
                              SettlementEntity defender,
                              List<Movement> reinforcement,
                              BattleResult battleResult,
                              List<Integer> plunder) {
        var ownDef = PlayerInfo.builder()
                .settlementId(defender.getId())
                .settlementName(defender.getName())
                .playerName(movement.getTo().getPlayerName())
                .nation(defender.getNation())
                .units(battleResult.getUnitsBeforeBattle().get(0))
                .casualty(battleResult.getCasualties().get(0))
                .build();

        var off = PlayerInfo.builder()
                .settlementId(movement.getFrom().getVillageId())
                .settlementName(movement.getFrom().getVillageName())
                .playerName(movement.getFrom().getPlayerName())
                .nation(movement.getNation())
                .units(battleResult.getUnitsBeforeBattle().get(battleResult.getUnitsBeforeBattle().size() - 1))
                .casualty(battleResult.getCasualties().get(battleResult.getCasualties().size() - 1))
                .build();

        var participants = Arrays.asList(off, ownDef);

        for (var i = 0; i < reinforcement.size(); i++) {
            Movement current = reinforcement.get(i);
            participants.add(
                    PlayerInfo.builder()
                            .settlementId(current.getFrom().getVillageId())
                            .settlementName(current.getFrom().getVillageName())
                            .playerName(current.getFrom().getPlayerName())
                            .nation(current.getNation())
                            .units(battleResult.getUnitsBeforeBattle().get(i + 1))
                            .casualty(battleResult.getCasualties().get(i + 1))
                            .build());
        }

        List<ReportOwner> reportOwners = new ArrayList<>();
        reportOwners.add(new ReportOwner(attacker.getUserId(), 0));
        if (!defender.getKind().isOasis()) {
            reportOwners.add(new ReportOwner(defender.getUserId(), 0));
        }
        reinforcement.forEach(m -> reportOwners
                .add(new ReportOwner(m.getFrom().getUserId(), 0)));

        var report = ReportEntity.builder()
                .reportOwners(reportOwners)
                .mission(movement.getMission())
                .participants(participants)
                .dateTime(movement.getWhen())
                .bounty(plunder)
                .build();

        reportRepository.save(report);
    }

    @Override
    public UnreadAmountAndBriefs createReportsBrief(String playerId) {
        var cache = new HashMap<String, SettlementEntity>();
        List<ReportEntity> originalReports = reportRepository.findByPlayerIdInReportOwners(playerId);
        var amountUnreadReports = countUnreadReports(originalReports, playerId);
        var briefs = new ArrayList<ReportBrief>();
        for (var report : originalReports) {
            if (getReportStatus(report.getReportOwners(), playerId) == 2) {
                continue;
            }
            var brief = ReportBrief.builder()
                    .id(report.getId())
                    .read(getReportStatus(report.getReportOwners(), playerId) != 0)
                    .title(createTitle(cache, report))
                    .received(report.getDateTime())
                    .build();

            briefs.add(brief);
        }
        return new UnreadAmountAndBriefs(amountUnreadReports, briefs);
    }

    @Override
    public MilitaryReportResponse fetchReportById(String reportId, String playerId) {
        ReportEntity report = reportRepository.findById(reportId).orElseThrow();
        int ownerIndex = report.getReportOwners().stream()
                .map(ReportOwner::getPlayerId).toList()
                .indexOf(playerId);
        List<ReportOwner> owners = report.getReportOwners();
        ReportOwner owner = owners.get(ownerIndex);
        owner.setStatus(1);
        owners.set(ownerIndex, owner);
        reportRepository.save(report);

        //report for off
        if (report.getReportOwners().get(0).getPlayerId().equals(playerId)) {
            List<Integer> units = report.getParticipants().get(0).getUnits();
            List<Integer> casualty = report.getParticipants().get(0).getCasualty();
            return isAttackFailed(units, casualty)
                    ? getFailedReport(report)
                    : getFullReport(report);
        }
        //report for def
        if (report.getReportOwners().get(1).getPlayerId().equals(playerId)) {
            return getFullReport(report);
        }
        //report for reinforcement
        var reinforcementIndex = report.getReportOwners().stream()
                .map(ReportOwner::getPlayerId).toList().indexOf(playerId);
        return getReportForReinforcement(report, reinforcementIndex);
    }

    @Override
    public void deleteById(String reportId, String userId) {
        ReportEntity report = reportRepository.findById(reportId).orElseThrow();
        int ownerIndex = report.getReportOwners().stream()
                .map(ReportOwner::getPlayerId).toList().indexOf(userId);
        List<ReportOwner> owners = report.getReportOwners();
        owners.set(ownerIndex, new ReportOwner(owners.get(ownerIndex).getPlayerId(), 2));
        boolean isAllDeleted = owners.stream().noneMatch(owner -> owner.getStatus() != 2);
        if (isAllDeleted) {
            reportRepository.deleteById(reportId);
        } else {
            reportRepository.save(report);
        }
    }

    private boolean isAttackFailed(List<Integer> attackers, List<Integer> casualty) {
        for (int i = 0; i < attackers.size(); i++) {
            if (attackers.get(i) > (casualty.get(i))) {
                return false;
            }
        }
        return true;
    }

    private MilitaryReportResponse getFailedReport(ReportEntity report) {
        PlayerInfo def = report.getParticipants().get(1);
        def.setUnits(new ArrayList<>());
        def.setCasualty(new ArrayList<>());
        return MilitaryReportResponse.builder()
                .id(report.getId())
                .failed(true)
                .off(report.getParticipants().get(0))
                .def(def)
                .mission(report.getMission())
                .dateTime(report.getDateTime())
                .bounty(Arrays.asList(0, 0, 0, 0))
                .build();
    }

    private MilitaryReportResponse getFullReport(ReportEntity report) {
        List<PlayerInfo> defenceSublist = report.getParticipants().stream().skip(2).toList();
        return MilitaryReportResponse.builder()
                .id(report.getId())
                .off(report.getParticipants().get(0))
                .def(report.getParticipants().get(1))
                .reinforcements(groupAndReduceDefence(defenceSublist))
                .mission(report.getMission())
                .dateTime(report.getDateTime())
                .failed(false)
                .bounty(report.getBounty())
                .build();
    }

    private MilitaryReportResponse getReportForReinforcement(ReportEntity report, int index) {
        var def = report.getParticipants().get(1);
        def.setUnits(new ArrayList<>());
        def.setCasualty(new ArrayList<>());
        return MilitaryReportResponse.builder()
                .id(report.getId())
                .def(def)
                .reinforcements(groupAndReduceDefence(Collections.singletonList(report.getParticipants().get(index))))
                .mission(report.getMission())
                .dateTime(report.getDateTime())
                .failed(false)
                .bounty(Arrays.asList(0, 0, 0, 0))
                .build();
    }

    private List<DefenseInfo> groupAndReduceDefence(List<PlayerInfo> defenceSublist) {
        List<DefenseInfo> result = new ArrayList<>();
        var groupedByNation = defenceSublist.stream()
                .collect(Collectors.groupingBy(PlayerInfo::getNation));
        groupedByNation.forEach((key, value) -> {
            var sumUnits = Arrays.asList(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
            var sumCasualty = Arrays.asList(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
            for (var playerInfo : value) {
                for (var i = 0; i < playerInfo.getUnits().size(); i++) {
                    sumUnits.set(i, sumUnits.get(i) + playerInfo.getUnits().get(i));
                    sumCasualty.set(i, sumCasualty.get(i) + playerInfo.getCasualty().get(i));
                }
            }
            result.add(
                    DefenseInfo.builder()
                            .nation(key)
                            .units(sumUnits)
                            .casualty(sumCasualty)
                            .build());
        });
        return result;
    }

    private int countUnreadReports(List<ReportEntity> reports, String playerId) {
        if (!reports.isEmpty()) {
            return reports.stream()
                    .filter(report -> findReportOwnerById(report.getReportOwners(), playerId)
                            .getStatus() == 0).toList().size();
        }
        return 0;
    }

    private ReportOwner findReportOwnerById(List<ReportOwner> owners, String playerId) {
        return owners.stream().filter(owner -> owner.getPlayerId().equals(playerId))
                .findFirst().orElseThrow();
    }

    private int getReportStatus(List<ReportOwner> owners, String playerId) {
        return owners.stream()
                .filter(owner -> owner.getPlayerId().equals(playerId)).toList().get(0).getStatus();
    }

    private String createTitle(
            Map<String, SettlementEntity> cache,
            ReportEntity report) {
        SettlementEntity from;
        SettlementEntity to;
        String firstParticipantSettlementId = report.getParticipants().get(0).getSettlementId();
        String secondParticipantSettlementId = report.getParticipants().get(1).getSettlementId();
        if (cache.containsKey(firstParticipantSettlementId)) {
            from = cache.get(firstParticipantSettlementId);
        } else {
            from = settlementRepository.findById(firstParticipantSettlementId).orElseThrow();
            cache.putIfAbsent(from.getId(), from);
        }
        if (cache.containsKey(secondParticipantSettlementId)) {
            to = cache.get(secondParticipantSettlementId);
        } else {
            to = settlementRepository.findById(secondParticipantSettlementId).orElseThrow();
            cache.putIfAbsent(to.getId(), to);
        }
        return String.format("%s %s %s", from.getName(), getMission(report.getMission()), to.getName());
    }

    String getMission(Mission mission) {
        return switch (mission) {
            case reinforcement -> "reinforces";
            case attack -> "attacks";
            default -> "raids";
        };
    }
}
