package xyz.qruto.java_server.models.responses;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MessageResponse {
    private String id;
    private String subject;
    private String body;
    private String senderId;
    private String senderName;
    private LocalDateTime dateTime;
}
