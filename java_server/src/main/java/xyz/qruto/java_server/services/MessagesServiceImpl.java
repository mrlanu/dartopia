package xyz.qruto.java_server.services;

import org.modelmapper.ModelMapper;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import xyz.qruto.java_server.entities.MessageEntity;
import xyz.qruto.java_server.errors.UserErrorException;
import xyz.qruto.java_server.models.requests.MessageSendRequest;
import xyz.qruto.java_server.models.responses.MessageBriefResponse;
import xyz.qruto.java_server.models.responses.MessageResponse;
import xyz.qruto.java_server.models.responses.MessagesResponse;
import xyz.qruto.java_server.repositories.MessagesRepository;
import xyz.qruto.java_server.repositories.UserRepository;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;

@Service
public class MessagesServiceImpl implements MessagesService{

    private final MessagesRepository messagesRepository;
    private final UserRepository usersRepository;

    public MessagesServiceImpl(MessagesRepository messagesRepository,
                               UserRepository usersRepository) {
        this.messagesRepository = messagesRepository;
        this.usersRepository = usersRepository;
    }

    @Override
    public MessageResponse getMessageById(String messageId){
        var mapper = new ModelMapper();
        var messageEntity = messagesRepository.findById(messageId).orElseThrow();
        messageEntity.setRead(true);
        messagesRepository.save(messageEntity);
        return mapper.map(messageEntity, MessageResponse.class);
    }

    @Override
    public long countNewMessages(String recipientId) {
        return messagesRepository.countAllByRecipientIdAndVisibleForRecipientTrueAndReadFalse(recipientId);
    }

    @Override
    public MessagesResponse getAllBriefs(String userId, int page, int pageSize, boolean sent) {
        Page<MessageEntity> pagedResult;
        Sort sort = Sort.by(Sort.Direction.DESC, "dateTime");
        Pageable pageable = PageRequest.of(page - 1, pageSize, sort);
        if (sent){
            pagedResult = messagesRepository
                    .findAllBySenderIdAndVisibleForSenderTrue(userId, pageable);
        } else {
            pagedResult = messagesRepository
                    .findAllByRecipientIdAndVisibleForRecipientTrue(userId, pageable);
        }
        List<MessageBriefResponse> messagesList =  pagedResult.getContent().stream()
                .map(message -> MessageBriefResponse.builder()
                        .id(message.getId())
                        .subject(message.getSubject())
                        .senderName(message.getSenderName())
                        .senderId(message.getSenderId())
                        .recipientId(message.getRecipientId())
                        .recipientName(message.getRecipientName())
                        .read(message.isRead())
                        .time(message.getDateTime())
                        .build())
                .sorted(Comparator.comparing(MessageBriefResponse::getTime).reversed())
                .toList();
        return MessagesResponse.builder()
                .messagesList(messagesList)
                .currentPage(page)
                .itemsPerPage(pageSize)
                .totalPages((int) Math.ceil((double) pagedResult.getTotalElements()
                        / pagedResult.getPageable().getPageSize()))
                .totalItems((int) pagedResult.getTotalElements())
                .build();
    }

    @Override
    public MessageEntity sendMessage(MessageSendRequest messageSendRequest, String userId) {
        var sender = usersRepository.findById(userId)
                .orElseThrow(() ->
                        new UserErrorException(String.format("User with id - %s is not exist.",
                                userId)));
        var recipient = usersRepository.findByName(messageSendRequest.getRecipientName())
                .orElseThrow(() ->
                        new UserErrorException(String.format("User %s is not exist.",
                                messageSendRequest.getRecipientName())));
        if (recipient.getId().equals(sender.getId())) {
            throw new UserErrorException("You cannot send this message.");
        }
        var messageEntity = MessageEntity.builder()
                .subject(messageSendRequest.getSubject())
                .body(messageSendRequest.getBody())
                .senderId(sender.getId())
                .senderName(sender.getName())
                .visibleForRecipient(true)
                .visibleForSender(true)
                .recipientId(recipient.getId())
                .recipientName(messageSendRequest.getRecipientName())
                .dateTime(LocalDateTime.now())
                .read(false)
                .build();
        return messagesRepository.save(messageEntity);
    }

    @Override
    public void read(List<String> messagesId) {
        List<MessageEntity> messageEntities = messagesRepository.findAllById(messagesId);
        messageEntities.forEach(message -> message.setRead(true));
        messagesRepository.saveAll(messageEntities);
    }

    @Override
    public void delete(List<String> messagesId, String requestOwnerId){
        messagesRepository.findAllById(messagesId).forEach(
                message -> {
                    if (requestOwnerId.equals(message.getSenderId())){
                        if (message.isVisibleForRecipient()){
                            message.setVisibleForSender(false);
                            messagesRepository.save(message);
                        }else {
                            messagesRepository.deleteById(message.getId());
                        }
                    }else {
                        if (message.isVisibleForSender()){
                            message.setVisibleForRecipient(false);
                            messagesRepository.save(message);
                        }else {
                            messagesRepository.deleteById(message.getId());
                        }
                    }
                }
        );
    }
}
