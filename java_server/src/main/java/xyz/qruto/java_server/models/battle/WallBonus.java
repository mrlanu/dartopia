package xyz.qruto.java_server.models.battle;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class WallBonus<T> {
    private T defBonus;
    private T def;

    public static <T> WallBonus<T> off(T defBonus, T def){
        return new WallBonus<>(defBonus, def);
    }
}
