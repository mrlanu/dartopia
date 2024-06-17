package xyz.qruto.java_server.models.responses;

import java.util.List;

public record UnreadAmountAndBriefs(int amount, List<ReportBrief> briefs) {
}
