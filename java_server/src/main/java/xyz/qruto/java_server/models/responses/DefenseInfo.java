package xyz.qruto.java_server.models.responses;

import lombok.Builder;
import lombok.Data;
import xyz.qruto.java_server.models.Nations;

import java.util.List;

@Data
@Builder
public class DefenseInfo {
    private Nations nation;
    private List<Integer> units;
    private List<Integer> casualty;
}
