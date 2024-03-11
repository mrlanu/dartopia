// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proba.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Proba _$ProbaFromJson(Map<String, dynamic> json) => Proba(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
    );

Map<String, dynamic> _$ProbaToJson(Proba instance) => <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
    };
