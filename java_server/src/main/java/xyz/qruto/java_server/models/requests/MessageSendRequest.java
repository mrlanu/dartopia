package xyz.qruto.java_server.models.requests;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MessageSendRequest {
    private String senderId;
    private String senderName;
    private String recipientName;
    private String subject;
    private String body;
}
