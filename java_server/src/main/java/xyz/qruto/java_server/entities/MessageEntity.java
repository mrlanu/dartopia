package xyz.qruto.java_server.entities;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Document("messages")
@Data
@Builder
public class MessageEntity {
    @Id
    private String id;
    private String subject;
    private String body;
    private String senderId;
    private String senderName;
    private boolean visibleForSender;
    private boolean visibleForRecipient;
    private String recipientId;
    private String recipientName;
    private LocalDateTime dateTime;
    private boolean read;
}
