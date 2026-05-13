part of 'settings_cubit.dart';

enum SettingsStatus {
  initial,
  loading,
  success,
  failure,
}

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.settings,
    this.error,
  });

  final SettingsStatus status;
  final GameSettings? settings;
  final String? error;

  static const _unset = Object();

  SettingsState copyWith({
    SettingsStatus? status,
    GameSettings? settings,
    Object? error = _unset,
    bool clearError = false,
  }) {
    return SettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      error: clearError
          ? null
          : (identical(error, _unset) ? this.error : error as String?),
    );
  }

  @override
  List<Object?> get props => [status, settings, error];
}
