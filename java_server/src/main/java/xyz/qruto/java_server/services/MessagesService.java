package xyz.qruto.java_server.services;

import xyz.qruto.java_server.entities.MessageEntity;
import xyz.qruto.java_server.models.requests.MessageSendRequest;
import xyz.qruto.java_server.models.responses.MessageBriefResponse;
import xyz.qruto.java_server.models.responses.MessageResponse;

import java.util.List;

public interface MessagesService {
    List<MessageBriefResponse> getAllBriefs(String clientId, boolean sent);

    MessageEntity save(MessageSendRequest messageSendRequest);
    void read(List<String> messagesId);
    boolean delete(List<String> messagesId, String requestOwnerId);
    MessageResponse getMessageById(String messageId);
    long countNewMessages(String recipientId);
}
