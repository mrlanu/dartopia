import 'package:json_annotation/json_annotation.dart';

part 'proba.g.dart';

@JsonSerializable()
class Proba {

  @JsonKey(name: '_id')
  final String? id;

  final String firstName, lastName;
  final DateTime? dateOfBirth;

  Proba({this.id, required this.firstName, required this.lastName, this.dateOfBirth});


  factory Proba.fromJson(Map<String, dynamic> json) => _$ProbaFromJson(json);

  Map<String, dynamic> toJson() => _$ProbaToJson(this);
}
