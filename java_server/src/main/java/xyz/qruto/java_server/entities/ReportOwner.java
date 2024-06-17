package xyz.qruto.java_server.entities;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class ReportOwner {
    private String playerId;
    private int status;
}
