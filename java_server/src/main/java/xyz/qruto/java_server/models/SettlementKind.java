package xyz.qruto.java_server.models;

import xyz.qruto.java_server.entities.MapTile;

import java.util.Arrays;
import java.util.List;


public enum SettlementKind {
    water,
    gras_land,
    w,
    w_cr,
    c,
    c_cr,
    i,
    i_cr,
    cr,
    cr_cr,
    six,
    fifteen;

    public static final List<TileProbability> proportions = Arrays.asList(
            new TileProbability(SettlementKind.gras_land, 0.84),
            new TileProbability(SettlementKind.i, 0.02),
            new TileProbability(SettlementKind.i_cr, 0.02),
            new TileProbability(SettlementKind.cr, 0.02),
            new TileProbability(SettlementKind.cr_cr, 0.02),
            new TileProbability(SettlementKind.c, 0.02),
            new TileProbability(SettlementKind.c_cr, 0.02),
            new TileProbability(SettlementKind.w, 0.02),
            new TileProbability(SettlementKind.w_cr, 0.02)
    );

    public static MapTile getTile(SettlementKind kind, int x, int y) {
        return switch (kind) {
            case water -> MapTile.builder()
                    .corX(x)
                    .corY(y)
                    .name("Water")
                    .tileNumber(89)
                    .build();
            case gras_land -> MapTile.builder()
                    .corX(x)
                    .corY(y)
                    .name("Gras land")
                    .tileNumber(0)
                    .build();
            case i -> MapTile.builder()
                    .corX(x)
                    .corY(y)
                    .name("Iron Oasis")
                    .tileNumber(3)
                    .build();
            case i_cr -> MapTile.builder()
                    .corX(x)
                    .corY(y)
                    .name("Iron Crop Oasis")
                    .tileNumber(5)
                    .build();
            case cr -> MapTile.builder()
                    .corX(x)
                    .corY(y)
                    .name("Crop Oasis")
                    .tileNumber(17)
                    .build();
            case cr_cr -> MapTile.builder()
                    .corX(x)
                    .corY(y)
                    .name("Crop Crop Oasis")
                    .tileNumber(19)
                    .build();
            case c -> MapTile.builder()
                    .corX(x)
                    .corY(y)
                    .name("Clay Oasis")
                    .tileNumber(27)
                    .build();
            case c_cr -> MapTile.builder()
                    .corX(x)
                    .corY(y)
                    .name("Clay Crop Oasis")
                    .tileNumber(29)
                    .build();
            case w -> MapTile.builder()
                    .corX(x)
                    .corY(y)
                    .name("Wood Oasis")
                    .tileNumber(41)
                    .build();
            case w_cr -> MapTile.builder()
                    .corX(x)
                    .corY(y)
                    .name("Wood Crop Oasis")
                    .tileNumber(43)
                    .build();
            default -> throw new IllegalStateException("Unexpected value: " + kind);
        };
    }
}
