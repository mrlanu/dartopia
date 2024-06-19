package xyz.qruto.java_server.models.executables;

import xyz.qruto.java_server.entities.SettlementEntity;

import java.time.LocalDateTime;

public interface Executable {
    int execute(SettlementEntity settlement);
    LocalDateTime getExecutionTime();
}
