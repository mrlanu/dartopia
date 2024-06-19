package xyz.qruto.java_server.models.battle;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class BattleSides<T> {
    private T off;
    private T def;

    public static <T> BattleSides<T> off(T off, T def){
        return new BattleSides<>(off, def);
    }
}
