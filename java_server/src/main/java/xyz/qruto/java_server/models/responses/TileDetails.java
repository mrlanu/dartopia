package xyz.qruto.java_server.models.responses;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class TileDetails {
    private String id;
    private String playerName;
    private String name;
    private int x;
    private int y;
    private int population;
    private List<Integer> animals;
    private double distance;
}
