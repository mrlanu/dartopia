package xyz.qruto.java_server.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import xyz.qruto.java_server.entities.MessageEntity;

import java.util.List;

public interface MessagesRepository extends MongoRepository<MessageEntity, String> {
    List<MessageEntity> findAllByRecipientIdAndVisibleForRecipientTrue(String recipientId);
    List<MessageEntity> findAllBySenderIdAndVisibleForSenderTrue(String senderId);
    long countAllByRecipientIdAndVisibleForRecipientAndRead(String recipientId, boolean visible, boolean read);
}
