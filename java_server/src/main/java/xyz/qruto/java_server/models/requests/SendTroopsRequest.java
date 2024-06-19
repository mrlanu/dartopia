package xyz.qruto.java_server.models.requests;

import lombok.Builder;
import lombok.Data;
import xyz.qruto.java_server.models.Mission;

import java.util.List;

@Data
@Builder
public class SendTroopsRequest {
    private String to;
    private List<Integer> units;
    private Mission mission;
}
