import 'package:bloc/bloc.dart';
import 'package:dartopia/rally_point/rally_point.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

part 'send_troops_state.dart';

class SendTroopsCubit extends Cubit<SendTroopsState> {
  SendTroopsCubit({required this.troopMovementsRepository})
      : super(const SendTroopsState());

  final TroopMovementsRepository troopMovementsRepository;

  void setTargetCoordinates({int? x, int? y}) {
    var newCoordinates = [...state.targetCoordinates];
    if(x != null){
      newCoordinates[0] = x;
    }
    if(y != null){
      newCoordinates[1] = y;
    }
    emit(state.copyWith(targetCoordinates: newCoordinates));
  }

  void setContract(TroopsSendContract? contract) {
    emit(state.copyWith(contract: contract));
  }

  void setUnits(List<int> units) {
    emit(state.copyWith(units: units));
  }

  void setUnit(int index, int amount) {
    List<int> updatedUnits = List.from(state.units);
    updatedUnits[index] = amount;
    emit(state.copyWith(units: updatedUnits));
  }

  void setTarget1(String target) {
    emit(state.copyWith(target1: target));
  }

  void setMission(Mission mission) {
    emit(state.copyWith(mission: mission));
  }

  void setStatus(SendTroopsStatus status) {
    emit(state.copyWith(status: status));
  }

  Future<void> submitForm({required String currentSettlementId}) async {
    emit(state.copyWith(status: SendTroopsStatus.processing));
    final contract = TroopsSendContract(
        corX: state.targetCoordinates[0],
        corY: state.targetCoordinates[1],
        units: state.units,
        when: DateTime.now());
    final confirmedContract =
        await troopMovementsRepository.fetchSendTroopsContract(
            fromSettlementId: currentSettlementId, contract: contract);
    emit(state.copyWith(
        status: SendTroopsStatus.confirming, contract: confirmedContract));
  }

  Future<void> sendTroops({required String currentSettlementId}) async {
    final request = SendTroopsRequest(
        to: state.contract!.settlementId!,
        units: state.units,
        mission: state.mission);
    await troopMovementsRepository.sendTroops(request, currentSettlementId);
  }
}
