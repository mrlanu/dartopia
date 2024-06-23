// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'messages_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MessagesResponse _$MessagesResponseFromJson(Map<String, dynamic> json) {
  return _MessagesResponse.fromJson(json);
}

/// @nodoc
mixin _$MessagesResponse {
  List<MessagesModel> get messagesList => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  int get itemsPerPage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessagesResponseCopyWith<MessagesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessagesResponseCopyWith<$Res> {
  factory $MessagesResponseCopyWith(
          MessagesResponse value, $Res Function(MessagesResponse) then) =
      _$MessagesResponseCopyWithImpl<$Res, MessagesResponse>;
  @useResult
  $Res call(
      {List<MessagesModel> messagesList,
      int currentPage,
      int totalItems,
      int totalPages,
      int itemsPerPage});
}

/// @nodoc
class _$MessagesResponseCopyWithImpl<$Res, $Val extends MessagesResponse>
    implements $MessagesResponseCopyWith<$Res> {
  _$MessagesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messagesList = null,
    Object? currentPage = null,
    Object? totalItems = null,
    Object? totalPages = null,
    Object? itemsPerPage = null,
  }) {
    return _then(_value.copyWith(
      messagesList: null == messagesList
          ? _value.messagesList
          : messagesList // ignore: cast_nullable_to_non_nullable
              as List<MessagesModel>,
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
abstract class _$$MessagesResponseImplCopyWith<$Res>
    implements $MessagesResponseCopyWith<$Res> {
  factory _$$MessagesResponseImplCopyWith(_$MessagesResponseImpl value,
          $Res Function(_$MessagesResponseImpl) then) =
      __$$MessagesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<MessagesModel> messagesList,
      int currentPage,
      int totalItems,
      int totalPages,
      int itemsPerPage});
}

/// @nodoc
class __$$MessagesResponseImplCopyWithImpl<$Res>
    extends _$MessagesResponseCopyWithImpl<$Res, _$MessagesResponseImpl>
    implements _$$MessagesResponseImplCopyWith<$Res> {
  __$$MessagesResponseImplCopyWithImpl(_$MessagesResponseImpl _value,
      $Res Function(_$MessagesResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messagesList = null,
    Object? currentPage = null,
    Object? totalItems = null,
    Object? totalPages = null,
    Object? itemsPerPage = null,
  }) {
    return _then(_$MessagesResponseImpl(
      messagesList: null == messagesList
          ? _value._messagesList
          : messagesList // ignore: cast_nullable_to_non_nullable
              as List<MessagesModel>,
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
class _$MessagesResponseImpl implements _MessagesResponse {
  const _$MessagesResponseImpl(
      {required final List<MessagesModel> messagesList,
      required this.currentPage,
      required this.totalItems,
      required this.totalPages,
      required this.itemsPerPage})
      : _messagesList = messagesList;

  factory _$MessagesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessagesResponseImplFromJson(json);

  final List<MessagesModel> _messagesList;
  @override
  List<MessagesModel> get messagesList {
    if (_messagesList is EqualUnmodifiableListView) return _messagesList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messagesList);
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
    return 'MessagesResponse(messagesList: $messagesList, currentPage: $currentPage, totalItems: $totalItems, totalPages: $totalPages, itemsPerPage: $itemsPerPage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessagesResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._messagesList, _messagesList) &&
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
      const DeepCollectionEquality().hash(_messagesList),
      currentPage,
      totalItems,
      totalPages,
      itemsPerPage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessagesResponseImplCopyWith<_$MessagesResponseImpl> get copyWith =>
      __$$MessagesResponseImplCopyWithImpl<_$MessagesResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessagesResponseImplToJson(
      this,
    );
  }
}

abstract class _MessagesResponse implements MessagesResponse {
  const factory _MessagesResponse(
      {required final List<MessagesModel> messagesList,
      required final int currentPage,
      required final int totalItems,
      required final int totalPages,
      required final int itemsPerPage}) = _$MessagesResponseImpl;

  factory _MessagesResponse.fromJson(Map<String, dynamic> json) =
      _$MessagesResponseImpl.fromJson;

  @override
  List<MessagesModel> get messagesList;
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
  _$$MessagesResponseImplCopyWith<_$MessagesResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
