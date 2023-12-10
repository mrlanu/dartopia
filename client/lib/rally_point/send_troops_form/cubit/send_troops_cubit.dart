import 'package:bloc/bloc.dart';
import 'package:dartopia/rally_point/rally_point.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

part 'send_troops_state.dart';

class SendTroopsCubit extends Cubit<SendTroopsState> {
  SendTroopsCubit({required this.troopMovementsRepository})
      : super(const SendTroopsState());

  final TroopMovementsRepository troopMovementsRepository;

  void setX(int x){
    emit(state.copyWith(x: x));
  }

  void setY(int y){
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

  void setKind(int kind) {
    emit(state.copyWith(kind: kind));
  }

  void setStatus(SendTroopsStatus status) {
    emit(state.copyWith(status: status));
  }

  Future<void> submitForm() async {
    emit(state.copyWith(status: SendTroopsStatus.processing));
    await Future.delayed(const Duration(seconds: 1));
    if (state.tileDetails == null) {
      final tile =
          await troopMovementsRepository.fetchTileDetails(state.x, state.y);
      emit(state.copyWith(
          status: SendTroopsStatus.confirming, tileDetails: tile));
    } else {
      emit(state.copyWith(status: SendTroopsStatus.confirming));
    }
  }

  Future<void> sendTroops() async {
    final request = SendTroopsRequest(to: state.tileDetails!.id, units: state.units, mission: Mission.raid);
    await troopMovementsRepository.sendTroops(request, '654eaeb5693f198560bc1e5a');
  }
}
