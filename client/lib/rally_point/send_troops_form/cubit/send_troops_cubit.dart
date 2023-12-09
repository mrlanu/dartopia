import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'send_troops_state.dart';

class SendTroopsCubit extends Cubit<SendTroopsState> {
  SendTroopsCubit() : super(const SendTroopsState());

  void setX(int x) {
    emit(state.copyWith(x: x));
  }

  void setY(int y) {
    emit(state.copyWith(y: y));
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

  void submitForm() {
    // Access state.numbers to get the list of numbers
    print(state.units);
    // Add your form submission logic here
  }
}
