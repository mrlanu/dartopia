package xyz.qruto.java_server.models;

import lombok.Getter;
import xyz.qruto.java_server.entities.MapTile;

import java.util.Arrays;
import java.util.List;

@Getter
public enum SettlementKind {
    water(89, false),
    gras_land(0, false),
    w(41, true),
    w_cr(43, true),
    c(27, true),
    c_cr(29, true),
    i(3, true),
    i_cr(5, true),
    cr(17, true),
    cr_cr(19, true),
    six(56, false),
    fifteen(56, false);

    private final int code;
    private final boolean isOasis;

    SettlementKind(int code, boolean isOasis) {
        this.code = code;
        this.isOasis = isOasis;
    }

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
                    .tileNumber(water.getCode())
                    .empty(true)
                    .build();
            case gras_land -> MapTile.builder()
                    .corX(x)
                    .corY(y)
                    .name("Gras land")
                    .tileNumber(gras_land.getCode())
                    .empty(true)
                    .build();
            case i -> MapTile.builder()
                    .corX(x)
                    .corY(y)
                    .name("Iron Oasis")
                    .tileNumber(i.getCode())
                    .empty(true)
                    .build();
            case i_cr -> MapTile.builder()
                    .corX(x)
                    .corY(y)
                    .name("Iron Crop Oasis")
                    .tileNumber(i_cr.getCode())
                    .empty(true)
                    .build();
            case cr -> MapTile.builder()
                    .corX(x)
                    .corY(y)
                    .name("Crop Oasis")
                    .tileNumber(cr.getCode())
                    .empty(true)
                    .build();
            case cr_cr -> MapTile.builder()
                    .corX(x)
                    .corY(y)
                    .name("Crop Crop Oasis")
                    .tileNumber(cr_cr.getCode())
                    .empty(true)
                    .build();
            case c -> MapTile.builder()
                    .corX(x)
                    .corY(y)
                    .name("Clay Oasis")
                    .tileNumber(c.getCode())
                    .empty(true)
                    .build();
            case c_cr -> MapTile.builder()
                    .corX(x)
                    .corY(y)
                    .name("Clay Crop Oasis")
                    .empty(true)
                    .tileNumber(c_cr.getCode())
                    .build();
            case w -> MapTile.builder()
                    .corX(x)
                    .corY(y)
                    .name("Wood Oasis")
                    .tileNumber(w.getCode())
                    .empty(true)
                    .build();
            case w_cr -> MapTile.builder()
                    .corX(x)
                    .corY(y)
                    .name("Wood Crop Oasis")
                    .tileNumber(w_cr.getCode())
                    .empty(true)
                    .build();
            default -> throw new IllegalStateException("Unexpected value: " + kind);
        };
    }
}
