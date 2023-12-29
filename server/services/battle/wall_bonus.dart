class WallBonus<T> {

  const WallBonus(this.defBonus, this.def);

  factory WallBonus.off(T defBonus, T def) {
    return WallBonus(defBonus, def);
  }
  final T defBonus;
  final T def;
}
