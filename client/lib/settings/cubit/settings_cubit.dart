import 'package:bloc/bloc.dart';
import 'package:dartopia/settings/settings_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repository) : super(const SettingsState());

  final SettingsRepository _repository;

  /// Loads full server settings (`GET /settings`). Safe to call multiple times.
  Future<void> load() async {
    emit(state.copyWith(status: SettingsStatus.loading, clearError: true));
    try {
      final settings = await _repository.fetchSettings();
      emit(state.copyWith(
        status: SettingsStatus.success,
        settings: settings,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
