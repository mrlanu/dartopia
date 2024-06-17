package xyz.qruto.java_server.models.responses;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class ReportBrief {
    private String id;
    private boolean read;
    private String title;
    private LocalDateTime received;
}
