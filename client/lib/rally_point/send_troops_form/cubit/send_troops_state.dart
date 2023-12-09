part of 'send_troops_cubit.dart';

class SendTroopsState extends Equatable {
  const SendTroopsState(
      {this.x = 0,
      this.y = 0,
      this.units = const [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      this.target1,
      this.target2,
      this.kind = 2});

  final int x;
  final int y;
  final List<int> units;
  final String? target1;
  final String? target2;
  final int kind;

  List<String> get options => ['option 1', 'option 2', 'option 3'];

  SendTroopsState copyWith({
    int? x,
    int? y,
    String? target1,
    String? target2,
    List<int>? units,
    int? kind,
  }) {
    return SendTroopsState(
      x: x ?? this.x,
      y: y ?? this.y,
      target1: target1 ?? this.target1,
      target2: target2 ?? this.target2,
      units: units ?? this.units,
      kind: kind ?? this.kind,
    );
  }

  @override
  List<Object?> get props => [x, y, units, target1, target2, kind];
}
