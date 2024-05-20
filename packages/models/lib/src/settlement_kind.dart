enum SettlementKind {
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

  static SettlementKind getKindByTile(int tile) {
    return switch (tile) {
      3 => SettlementKind.i,
      5 => SettlementKind.i_cr,
      17 => SettlementKind.cr,
      19 => SettlementKind.cr_cr,
      27 => SettlementKind.c,
      29 => SettlementKind.c_cr,
      41 => SettlementKind.w,
      43 => SettlementKind.w_cr,
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
