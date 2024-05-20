enum SettlementKind {
  w,
  w_cr,
  w_w,
  c,
  c_cr,
  c_c,
  i,
  i_cr,
  i_i,
  cr,
  cr_cr,
  six,
  fifteen;

  static SettlementKind getKindByTile(int tile) {
    return switch (tile) {
      3 => SettlementKind.i,
      5 => SettlementKind.i_cr,
      7 => SettlementKind.i_i,
      17 => SettlementKind.cr,
      19 => SettlementKind.cr_cr,
      27 => SettlementKind.c,
      29 => SettlementKind.c_cr,
      31 => SettlementKind.c_c,
      41 => SettlementKind.w,
      43 => SettlementKind.w_cr,
      45 => SettlementKind.w_w,
      _ => throw const FormatException('Invalid'),
    };
  }
}

extension XSettlementKind on SettlementKind {
  bool get isOasis {
    return index <= 10;
  }

  bool get isNotOasis {
    return index > 10;
  }
}
