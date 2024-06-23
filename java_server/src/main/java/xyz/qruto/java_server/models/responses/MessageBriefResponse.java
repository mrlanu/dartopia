package xyz.qruto.java_server.models.responses;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class MessageBriefResponse {
    private String id;
    private String subject;
    private String senderName;
    private String senderId;
    private String recipientName;
    private String recipientId;
    private boolean read;
    private LocalDateTime time;
}
