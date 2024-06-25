package xyz.qruto.java_server.services;

import xyz.qruto.java_server.entities.MessageEntity;
import xyz.qruto.java_server.models.requests.MessageSendRequest;
import xyz.qruto.java_server.models.responses.MessageResponse;
import xyz.qruto.java_server.models.responses.MessagesResponse;

import java.util.List;

public interface MessagesService {
    MessagesResponse getAllBriefs(String clientId, int page, int pageSize, boolean sent);

    MessageEntity save(MessageSendRequest messageSendRequest);
    void read(List<String> messagesId);
    void delete(List<String> messagesId, String requestOwnerId);
    MessageResponse getMessageById(String messageId);
    long countNewMessages(String recipientId);
}
