part of 'send_troops_cubit.dart';

enum SendTroopsStatus { selecting, processing, confirming }

class SendTroopsState extends Equatable {
  const SendTroopsState(
      {this.status = SendTroopsStatus.selecting,
      this.x = 0,
      this.y = 0,
      this.tileDetails,
      this.units = const [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      this.target1,
      this.target2,
      this.mission = Mission.reinforcement});

  final SendTroopsStatus status;
  final int x;
  final int y;
  final TileDetails? tileDetails;
  final List<int> units;
  final String? target1;
  final String? target2;
  final Mission mission;

  List<String> get options => ['option 1', 'option 2', 'option 3'];

  SendTroopsState copyWith({
    SendTroopsStatus? status,
    int? x,
    int? y,
    TileDetails? tileDetails,
    String? target1,
    String? target2,
    List<int>? units,
    Mission? mission,
  }) {
    return SendTroopsState(
      status: status ?? this.status,
      x: x ?? this.x,
      y: y ?? this.y,
      tileDetails: tileDetails ?? this.tileDetails,
      target1: target1 ?? this.target1,
      target2: target2 ?? this.target2,
      units: units ?? this.units,
      mission: mission ?? this.mission,
    );
  }

  @override
  List<Object?> get props =>
      [status, x, y, tileDetails, units, target1, target2, mission];
}
