package xyz.qruto.java_server.repositories;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import xyz.qruto.java_server.entities.MessageEntity;

import java.util.List;

public interface MessagesRepository extends MongoRepository<MessageEntity, String> {
    Page<MessageEntity> findAllByRecipientIdAndVisibleForRecipientTrue(String recipientId, Pageable pageable);
    Page<MessageEntity> findAllBySenderIdAndVisibleForSenderTrue(String senderId, Pageable pageable);
    long countAllByRecipientIdAndVisibleForRecipientAndRead(String recipientId, boolean visible, boolean read);
}
