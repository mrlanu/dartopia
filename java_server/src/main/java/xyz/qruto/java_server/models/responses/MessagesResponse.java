package xyz.qruto.java_server.models.responses;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class MessagesResponse {
    private List<MessageBriefResponse> messagesList;
    private int currentPage;
    private int totalItems;
    private int totalPages;
    private int itemsPerPage;
}
