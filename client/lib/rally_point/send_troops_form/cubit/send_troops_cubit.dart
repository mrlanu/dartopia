import 'package:bloc/bloc.dart';
import 'package:dartopia/rally_point/rally_point.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

part 'send_troops_state.dart';

class SendTroopsCubit extends Cubit<SendTroopsState> {
  SendTroopsCubit({required this.troopMovementsRepository})
      : super(const SendTroopsState());

  final TroopMovementsRepository troopMovementsRepository;

  void setX(int x) {
    emit(state.copyWith(x: x));
  }

  void setY(int y) {
    emit(state.copyWith(y: y));
  }

  void setTileDetails(TileDetails? tileDetails) {
    emit(state.copyWith(tileDetails: tileDetails));
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

  Future<void> submitForm() async {
    emit(state.copyWith(status: SendTroopsStatus.processing));
    if (state.tileDetails == null) {
      final tile =
          await troopMovementsRepository.fetchTileDetails(state.x, state.y);
      emit(state.copyWith(
          status: SendTroopsStatus.confirming, tileDetails: tile));
    } else {
      emit(state.copyWith(status: SendTroopsStatus.confirming));
    }
  }

  Future<void> sendTroops({required String currentSettlementId}) async {
    final request = SendTroopsRequest(
        to: state.tileDetails!.id, units: state.units, mission: state.mission);
    await troopMovementsRepository.sendTroops(request, currentSettlementId);
  }
}
