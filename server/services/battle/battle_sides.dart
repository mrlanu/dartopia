class BattleSides<T> {
  BattleSides(this.off, this.def);

  factory BattleSides.off(T off, T def) {
    return BattleSides(off, def);
  }

  T off;
  T def;
}
