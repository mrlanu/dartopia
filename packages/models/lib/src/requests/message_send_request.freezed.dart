// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_send_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MessageSendRequest _$MessageSendRequestFromJson(Map<String, dynamic> json) {
  return _MessageSendRequest.fromJson(json);
}

/// @nodoc
mixin _$MessageSendRequest {
  String get recipientName => throw _privateConstructorUsedError;
  String get subject => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageSendRequestCopyWith<MessageSendRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageSendRequestCopyWith<$Res> {
  factory $MessageSendRequestCopyWith(
          MessageSendRequest value, $Res Function(MessageSendRequest) then) =
      _$MessageSendRequestCopyWithImpl<$Res, MessageSendRequest>;
  @useResult
  $Res call({String recipientName, String subject, String body});
}

/// @nodoc
class _$MessageSendRequestCopyWithImpl<$Res, $Val extends MessageSendRequest>
    implements $MessageSendRequestCopyWith<$Res> {
  _$MessageSendRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipientName = null,
    Object? subject = null,
    Object? body = null,
  }) {
    return _then(_value.copyWith(
      recipientName: null == recipientName
          ? _value.recipientName
          : recipientName // ignore: cast_nullable_to_non_nullable
              as String,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageSendRequestImplCopyWith<$Res>
    implements $MessageSendRequestCopyWith<$Res> {
  factory _$$MessageSendRequestImplCopyWith(_$MessageSendRequestImpl value,
          $Res Function(_$MessageSendRequestImpl) then) =
      __$$MessageSendRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String recipientName, String subject, String body});
}

/// @nodoc
class __$$MessageSendRequestImplCopyWithImpl<$Res>
    extends _$MessageSendRequestCopyWithImpl<$Res, _$MessageSendRequestImpl>
    implements _$$MessageSendRequestImplCopyWith<$Res> {
  __$$MessageSendRequestImplCopyWithImpl(_$MessageSendRequestImpl _value,
      $Res Function(_$MessageSendRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipientName = null,
    Object? subject = null,
    Object? body = null,
  }) {
    return _then(_$MessageSendRequestImpl(
      recipientName: null == recipientName
          ? _value.recipientName
          : recipientName // ignore: cast_nullable_to_non_nullable
              as String,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageSendRequestImpl implements _MessageSendRequest {
  const _$MessageSendRequestImpl(
      {required this.recipientName, required this.subject, required this.body});

  factory _$MessageSendRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageSendRequestImplFromJson(json);

  @override
  final String recipientName;
  @override
  final String subject;
  @override
  final String body;

  @override
  String toString() {
    return 'MessageSendRequest(recipientName: $recipientName, subject: $subject, body: $body)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageSendRequestImpl &&
            (identical(other.recipientName, recipientName) ||
                other.recipientName == recipientName) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, recipientName, subject, body);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageSendRequestImplCopyWith<_$MessageSendRequestImpl> get copyWith =>
      __$$MessageSendRequestImplCopyWithImpl<_$MessageSendRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageSendRequestImplToJson(
      this,
    );
  }
}

abstract class _MessageSendRequest implements MessageSendRequest {
  const factory _MessageSendRequest(
      {required final String recipientName,
      required final String subject,
      required final String body}) = _$MessageSendRequestImpl;

  factory _MessageSendRequest.fromJson(Map<String, dynamic> json) =
      _$MessageSendRequestImpl.fromJson;

  @override
  String get recipientName;
  @override
  String get subject;
  @override
  String get body;
  @override
  @JsonKey(ignore: true)
  _$$MessageSendRequestImplCopyWith<_$MessageSendRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
