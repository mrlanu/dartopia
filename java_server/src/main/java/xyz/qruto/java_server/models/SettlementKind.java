package xyz.qruto.java_server.models;

public enum SettlementKind {
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

    public static SettlementKind getKindByTile(int tile) {
        return switch (tile) {
            case 3 -> SettlementKind.i;
            case 5 -> SettlementKind.i_cr;
            case 17 -> SettlementKind.cr;
            case 19 -> SettlementKind.cr_cr;
            case 27 -> SettlementKind.c;
            case 29 -> SettlementKind.c_cr;
            case 41 -> SettlementKind.w;
            case 43 -> SettlementKind.w_cr;
            default -> throw new IllegalArgumentException("Invalid tile: " + tile);
        };
    }
}
