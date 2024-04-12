// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statistics_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

StatisticsModel _$StatisticsModelFromJson(Map<String, dynamic> json) {
  return _StatisticsModel.fromJson(json);
}

/// @nodoc
mixin _$StatisticsModel {
  int? get position => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  String get playerName => throw _privateConstructorUsedError;
  String get allianceName => throw _privateConstructorUsedError;
  int get population => throw _privateConstructorUsedError;
  int get villagesAmount => throw _privateConstructorUsedError;
  int get attackPoint => throw _privateConstructorUsedError;
  int get defensePoint => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StatisticsModelCopyWith<StatisticsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatisticsModelCopyWith<$Res> {
  factory $StatisticsModelCopyWith(
          StatisticsModel value, $Res Function(StatisticsModel) then) =
      _$StatisticsModelCopyWithImpl<$Res, StatisticsModel>;
  @useResult
  $Res call(
      {int? position,
      String playerId,
      String playerName,
      String allianceName,
      int population,
      int villagesAmount,
      int attackPoint,
      int defensePoint});
}

/// @nodoc
class _$StatisticsModelCopyWithImpl<$Res, $Val extends StatisticsModel>
    implements $StatisticsModelCopyWith<$Res> {
  _$StatisticsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = freezed,
    Object? playerId = null,
    Object? playerName = null,
    Object? allianceName = null,
    Object? population = null,
    Object? villagesAmount = null,
    Object? attackPoint = null,
    Object? defensePoint = null,
  }) {
    return _then(_value.copyWith(
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int?,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      playerName: null == playerName
          ? _value.playerName
          : playerName // ignore: cast_nullable_to_non_nullable
              as String,
      allianceName: null == allianceName
          ? _value.allianceName
          : allianceName // ignore: cast_nullable_to_non_nullable
              as String,
      population: null == population
          ? _value.population
          : population // ignore: cast_nullable_to_non_nullable
              as int,
      villagesAmount: null == villagesAmount
          ? _value.villagesAmount
          : villagesAmount // ignore: cast_nullable_to_non_nullable
              as int,
      attackPoint: null == attackPoint
          ? _value.attackPoint
          : attackPoint // ignore: cast_nullable_to_non_nullable
              as int,
      defensePoint: null == defensePoint
          ? _value.defensePoint
          : defensePoint // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StatisticsModelImplCopyWith<$Res>
    implements $StatisticsModelCopyWith<$Res> {
  factory _$$StatisticsModelImplCopyWith(_$StatisticsModelImpl value,
          $Res Function(_$StatisticsModelImpl) then) =
      __$$StatisticsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? position,
      String playerId,
      String playerName,
      String allianceName,
      int population,
      int villagesAmount,
      int attackPoint,
      int defensePoint});
}

/// @nodoc
class __$$StatisticsModelImplCopyWithImpl<$Res>
    extends _$StatisticsModelCopyWithImpl<$Res, _$StatisticsModelImpl>
    implements _$$StatisticsModelImplCopyWith<$Res> {
  __$$StatisticsModelImplCopyWithImpl(
      _$StatisticsModelImpl _value, $Res Function(_$StatisticsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = freezed,
    Object? playerId = null,
    Object? playerName = null,
    Object? allianceName = null,
    Object? population = null,
    Object? villagesAmount = null,
    Object? attackPoint = null,
    Object? defensePoint = null,
  }) {
    return _then(_$StatisticsModelImpl(
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int?,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      playerName: null == playerName
          ? _value.playerName
          : playerName // ignore: cast_nullable_to_non_nullable
              as String,
      allianceName: null == allianceName
          ? _value.allianceName
          : allianceName // ignore: cast_nullable_to_non_nullable
              as String,
      population: null == population
          ? _value.population
          : population // ignore: cast_nullable_to_non_nullable
              as int,
      villagesAmount: null == villagesAmount
          ? _value.villagesAmount
          : villagesAmount // ignore: cast_nullable_to_non_nullable
              as int,
      attackPoint: null == attackPoint
          ? _value.attackPoint
          : attackPoint // ignore: cast_nullable_to_non_nullable
              as int,
      defensePoint: null == defensePoint
          ? _value.defensePoint
          : defensePoint // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StatisticsModelImpl implements _StatisticsModel {
  const _$StatisticsModelImpl(
      {this.position,
      required this.playerId,
      required this.playerName,
      required this.allianceName,
      this.population = 0,
      this.villagesAmount = 1,
      this.attackPoint = 0,
      this.defensePoint = 0});

  factory _$StatisticsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StatisticsModelImplFromJson(json);

  @override
  final int? position;
  @override
  final String playerId;
  @override
  final String playerName;
  @override
  final String allianceName;
  @override
  @JsonKey()
  final int population;
  @override
  @JsonKey()
  final int villagesAmount;
  @override
  @JsonKey()
  final int attackPoint;
  @override
  @JsonKey()
  final int defensePoint;

  @override
  String toString() {
    return 'StatisticsModel(position: $position, playerId: $playerId, playerName: $playerName, allianceName: $allianceName, population: $population, villagesAmount: $villagesAmount, attackPoint: $attackPoint, defensePoint: $defensePoint)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatisticsModelImpl &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.allianceName, allianceName) ||
                other.allianceName == allianceName) &&
            (identical(other.population, population) ||
                other.population == population) &&
            (identical(other.villagesAmount, villagesAmount) ||
                other.villagesAmount == villagesAmount) &&
            (identical(other.attackPoint, attackPoint) ||
                other.attackPoint == attackPoint) &&
            (identical(other.defensePoint, defensePoint) ||
                other.defensePoint == defensePoint));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, position, playerId, playerName,
      allianceName, population, villagesAmount, attackPoint, defensePoint);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StatisticsModelImplCopyWith<_$StatisticsModelImpl> get copyWith =>
      __$$StatisticsModelImplCopyWithImpl<_$StatisticsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StatisticsModelImplToJson(
      this,
    );
  }
}

abstract class _StatisticsModel implements StatisticsModel {
  const factory _StatisticsModel(
      {final int? position,
      required final String playerId,
      required final String playerName,
      required final String allianceName,
      final int population,
      final int villagesAmount,
      final int attackPoint,
      final int defensePoint}) = _$StatisticsModelImpl;

  factory _StatisticsModel.fromJson(Map<String, dynamic> json) =
      _$StatisticsModelImpl.fromJson;

  @override
  int? get position;
  @override
  String get playerId;
  @override
  String get playerName;
  @override
  String get allianceName;
  @override
  int get population;
  @override
  int get villagesAmount;
  @override
  int get attackPoint;
  @override
  int get defensePoint;
  @override
  @JsonKey(ignore: true)
  _$$StatisticsModelImplCopyWith<_$StatisticsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
