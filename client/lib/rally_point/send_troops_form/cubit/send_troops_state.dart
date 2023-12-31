part of 'send_troops_cubit.dart';

enum SendTroopsStatus { selecting, processing, confirming }

class SendTroopsState extends Equatable {
  const SendTroopsState(
      {this.status = SendTroopsStatus.selecting,
      this.targetCoordinates = const [0, 0],
      this.contract,
      this.units = const [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      this.target1,
      this.target2,
      this.mission = Mission.reinforcement});

  final SendTroopsStatus status;
  final List<int> targetCoordinates;
  final TroopsSendContract? contract;
  final List<int> units;
  final String? target1;
  final String? target2;
  final Mission mission;

  List<String> get options => ['option 1', 'option 2', 'option 3'];

  SendTroopsState copyWith({
    SendTroopsStatus? status,
    List<int>? targetCoordinates,
    TroopsSendContract? contract,
    String? target1,
    String? target2,
    List<int>? units,
    Mission? mission,
  }) {
    return SendTroopsState(
      status: status ?? this.status,
      targetCoordinates: targetCoordinates ?? this.targetCoordinates,
      contract: contract ?? this.contract,
      target1: target1 ?? this.target1,
      target2: target2 ?? this.target2,
      units: units ?? this.units,
      mission: mission ?? this.mission,
    );
  }

  @override
  List<Object?> get props =>
      [status, targetCoordinates, contract, units, target1, target2, mission];
}
