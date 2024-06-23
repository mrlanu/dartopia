// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'messages_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MessagesModel _$MessagesModelFromJson(Map<String, dynamic> json) {
  return _MessagesModel.fromJson(json);
}

/// @nodoc
mixin _$MessagesModel {
  String get id => throw _privateConstructorUsedError;
  String get subject => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get recipientName => throw _privateConstructorUsedError;
  String get recipientId => throw _privateConstructorUsedError;
  bool get read => throw _privateConstructorUsedError;
  DateTime get time => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessagesModelCopyWith<MessagesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessagesModelCopyWith<$Res> {
  factory $MessagesModelCopyWith(
          MessagesModel value, $Res Function(MessagesModel) then) =
      _$MessagesModelCopyWithImpl<$Res, MessagesModel>;
  @useResult
  $Res call(
      {String id,
      String subject,
      String senderName,
      String senderId,
      String recipientName,
      String recipientId,
      bool read,
      DateTime time});
}

/// @nodoc
class _$MessagesModelCopyWithImpl<$Res, $Val extends MessagesModel>
    implements $MessagesModelCopyWith<$Res> {
  _$MessagesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? subject = null,
    Object? senderName = null,
    Object? senderId = null,
    Object? recipientName = null,
    Object? recipientId = null,
    Object? read = null,
    Object? time = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      recipientName: null == recipientName
          ? _value.recipientName
          : recipientName // ignore: cast_nullable_to_non_nullable
              as String,
      recipientId: null == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String,
      read: null == read
          ? _value.read
          : read // ignore: cast_nullable_to_non_nullable
              as bool,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessagesModelImplCopyWith<$Res>
    implements $MessagesModelCopyWith<$Res> {
  factory _$$MessagesModelImplCopyWith(
          _$MessagesModelImpl value, $Res Function(_$MessagesModelImpl) then) =
      __$$MessagesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String subject,
      String senderName,
      String senderId,
      String recipientName,
      String recipientId,
      bool read,
      DateTime time});
}

/// @nodoc
class __$$MessagesModelImplCopyWithImpl<$Res>
    extends _$MessagesModelCopyWithImpl<$Res, _$MessagesModelImpl>
    implements _$$MessagesModelImplCopyWith<$Res> {
  __$$MessagesModelImplCopyWithImpl(
      _$MessagesModelImpl _value, $Res Function(_$MessagesModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? subject = null,
    Object? senderName = null,
    Object? senderId = null,
    Object? recipientName = null,
    Object? recipientId = null,
    Object? read = null,
    Object? time = null,
  }) {
    return _then(_$MessagesModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      recipientName: null == recipientName
          ? _value.recipientName
          : recipientName // ignore: cast_nullable_to_non_nullable
              as String,
      recipientId: null == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String,
      read: null == read
          ? _value.read
          : read // ignore: cast_nullable_to_non_nullable
              as bool,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessagesModelImpl implements _MessagesModel {
  const _$MessagesModelImpl(
      {required this.id,
      required this.subject,
      required this.senderName,
      required this.senderId,
      required this.recipientName,
      required this.recipientId,
      required this.read,
      required this.time});

  factory _$MessagesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessagesModelImplFromJson(json);

  @override
  final String id;
  @override
  final String subject;
  @override
  final String senderName;
  @override
  final String senderId;
  @override
  final String recipientName;
  @override
  final String recipientId;
  @override
  final bool read;
  @override
  final DateTime time;

  @override
  String toString() {
    return 'MessagesModel(id: $id, subject: $subject, senderName: $senderName, senderId: $senderId, recipientName: $recipientName, recipientId: $recipientId, read: $read, time: $time)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessagesModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.recipientName, recipientName) ||
                other.recipientName == recipientName) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.read, read) || other.read == read) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, subject, senderName,
      senderId, recipientName, recipientId, read, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessagesModelImplCopyWith<_$MessagesModelImpl> get copyWith =>
      __$$MessagesModelImplCopyWithImpl<_$MessagesModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessagesModelImplToJson(
      this,
    );
  }
}

abstract class _MessagesModel implements MessagesModel {
  const factory _MessagesModel(
      {required final String id,
      required final String subject,
      required final String senderName,
      required final String senderId,
      required final String recipientName,
      required final String recipientId,
      required final bool read,
      required final DateTime time}) = _$MessagesModelImpl;

  factory _MessagesModel.fromJson(Map<String, dynamic> json) =
      _$MessagesModelImpl.fromJson;

  @override
  String get id;
  @override
  String get subject;
  @override
  String get senderName;
  @override
  String get senderId;
  @override
  String get recipientName;
  @override
  String get recipientId;
  @override
  bool get read;
  @override
  DateTime get time;
  @override
  @JsonKey(ignore: true)
  _$$MessagesModelImplCopyWith<_$MessagesModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
