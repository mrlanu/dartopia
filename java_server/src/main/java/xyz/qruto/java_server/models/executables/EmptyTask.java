package xyz.qruto.java_server.models.executables;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import xyz.qruto.java_server.entities.SettlementEntity;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EmptyTask implements Executable {
    private LocalDateTime when;

    @Override
    public int execute(SettlementEntity settlement) {
        return 0;
    }

    @Override
    public LocalDateTime getExecutionTime() {
        return when;
    }
}
