// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statistics_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

StatisticsResponse _$StatisticsResponseFromJson(Map<String, dynamic> json) {
  return _StatisticsResponse.fromJson(json);
}

/// @nodoc
mixin _$StatisticsResponse {
  List<StatisticsModel> get modelsList => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  int get itemsPerPage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StatisticsResponseCopyWith<StatisticsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatisticsResponseCopyWith<$Res> {
  factory $StatisticsResponseCopyWith(
          StatisticsResponse value, $Res Function(StatisticsResponse) then) =
      _$StatisticsResponseCopyWithImpl<$Res, StatisticsResponse>;
  @useResult
  $Res call(
      {List<StatisticsModel> modelsList,
      int currentPage,
      int totalItems,
      int totalPages,
      int itemsPerPage});
}

/// @nodoc
class _$StatisticsResponseCopyWithImpl<$Res, $Val extends StatisticsResponse>
    implements $StatisticsResponseCopyWith<$Res> {
  _$StatisticsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? modelsList = null,
    Object? currentPage = null,
    Object? totalItems = null,
    Object? totalPages = null,
    Object? itemsPerPage = null,
  }) {
    return _then(_value.copyWith(
      modelsList: null == modelsList
          ? _value.modelsList
          : modelsList // ignore: cast_nullable_to_non_nullable
              as List<StatisticsModel>,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      itemsPerPage: null == itemsPerPage
          ? _value.itemsPerPage
          : itemsPerPage // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StatisticsResponseImplCopyWith<$Res>
    implements $StatisticsResponseCopyWith<$Res> {
  factory _$$StatisticsResponseImplCopyWith(_$StatisticsResponseImpl value,
          $Res Function(_$StatisticsResponseImpl) then) =
      __$$StatisticsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<StatisticsModel> modelsList,
      int currentPage,
      int totalItems,
      int totalPages,
      int itemsPerPage});
}

/// @nodoc
class __$$StatisticsResponseImplCopyWithImpl<$Res>
    extends _$StatisticsResponseCopyWithImpl<$Res, _$StatisticsResponseImpl>
    implements _$$StatisticsResponseImplCopyWith<$Res> {
  __$$StatisticsResponseImplCopyWithImpl(_$StatisticsResponseImpl _value,
      $Res Function(_$StatisticsResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? modelsList = null,
    Object? currentPage = null,
    Object? totalItems = null,
    Object? totalPages = null,
    Object? itemsPerPage = null,
  }) {
    return _then(_$StatisticsResponseImpl(
      modelsList: null == modelsList
          ? _value._modelsList
          : modelsList // ignore: cast_nullable_to_non_nullable
              as List<StatisticsModel>,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      itemsPerPage: null == itemsPerPage
          ? _value.itemsPerPage
          : itemsPerPage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StatisticsResponseImpl implements _StatisticsResponse {
  const _$StatisticsResponseImpl(
      {required final List<StatisticsModel> modelsList,
      required this.currentPage,
      required this.totalItems,
      required this.totalPages,
      required this.itemsPerPage})
      : _modelsList = modelsList;

  factory _$StatisticsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$StatisticsResponseImplFromJson(json);

  final List<StatisticsModel> _modelsList;
  @override
  List<StatisticsModel> get modelsList {
    if (_modelsList is EqualUnmodifiableListView) return _modelsList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_modelsList);
  }

  @override
  final int currentPage;
  @override
  final int totalItems;
  @override
  final int totalPages;
  @override
  final int itemsPerPage;

  @override
  String toString() {
    return 'StatisticsResponse(modelsList: $modelsList, currentPage: $currentPage, totalItems: $totalItems, totalPages: $totalPages, itemsPerPage: $itemsPerPage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatisticsResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._modelsList, _modelsList) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.itemsPerPage, itemsPerPage) ||
                other.itemsPerPage == itemsPerPage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_modelsList),
      currentPage,
      totalItems,
      totalPages,
      itemsPerPage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StatisticsResponseImplCopyWith<_$StatisticsResponseImpl> get copyWith =>
      __$$StatisticsResponseImplCopyWithImpl<_$StatisticsResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StatisticsResponseImplToJson(
      this,
    );
  }
}

abstract class _StatisticsResponse implements StatisticsResponse {
  const factory _StatisticsResponse(
      {required final List<StatisticsModel> modelsList,
      required final int currentPage,
      required final int totalItems,
      required final int totalPages,
      required final int itemsPerPage}) = _$StatisticsResponseImpl;

  factory _StatisticsResponse.fromJson(Map<String, dynamic> json) =
      _$StatisticsResponseImpl.fromJson;

  @override
  List<StatisticsModel> get modelsList;
  @override
  int get currentPage;
  @override
  int get totalItems;
  @override
  int get totalPages;
  @override
  int get itemsPerPage;
  @override
  @JsonKey(ignore: true)
  _$$StatisticsResponseImplCopyWith<_$StatisticsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
