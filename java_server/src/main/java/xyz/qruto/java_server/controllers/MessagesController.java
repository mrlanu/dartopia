package xyz.qruto.java_server.controllers;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.*;
import xyz.qruto.java_server.entities.MessageEntity;
import xyz.qruto.java_server.models.UserDetailsImpl;
import xyz.qruto.java_server.models.requests.MessageSendRequest;
import xyz.qruto.java_server.models.responses.MessageBriefResponse;
import xyz.qruto.java_server.models.responses.MessageResponse;
import xyz.qruto.java_server.services.MessagesService;

import java.util.List;

@RestController
@RequestMapping("/messages")
public class MessagesController {
    private final MessagesService messagesService;

    public MessagesController(MessagesService messagesService) {
        this.messagesService = messagesService;
    }

    @PostMapping()
    public MessageEntity addMessage(@RequestBody MessageSendRequest messageSendRequest){
        return messagesService.save(messageSendRequest);
    }

    @GetMapping()
    public List<MessageBriefResponse> getAll(UsernamePasswordAuthenticationToken token,
                                             @RequestParam boolean sent){
        return messagesService.getAllBriefs(((UserDetailsImpl)token.getPrincipal()).getId(), sent);
    }

    @GetMapping("/{messageId}")
    public MessageResponse getMessageById(@PathVariable String messageId){
        return messagesService.getMessageById(messageId);
    }

    @PutMapping("/read")
    public void readMessage(@RequestBody List<String> messagesId){
        messagesService.read(messagesId);
    }

    @PutMapping("/delete")
    public void deleteMessage(@RequestBody List<String> messagesId, UsernamePasswordAuthenticationToken token){
        messagesService.delete(messagesId, ((UserDetailsImpl)token.getPrincipal()).getId());
    }

    @GetMapping("/count-new")
    public long countNewMessages(UsernamePasswordAuthenticationToken token){
        return messagesService.countNewMessages(((UserDetailsImpl)token.getPrincipal()).getId());
    }
}
