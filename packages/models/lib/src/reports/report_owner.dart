import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models/models.dart';

part 'report_owner.g.dart';

@JsonSerializable()
class ReportOwner {
  const ReportOwner({required this.playerId, this.status = 0});

  final String playerId;
  final int status; // new, read, deleted

  factory ReportOwner.fromJson(Map<String, dynamic> json) =>
      _$ReportOwnerFromJson(json);

  ReportOwner.fromMap(Map<String, dynamic> map)
      : playerId = map['playerId'] as String,
        status = map['status'] as int;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'playerId': playerId,
        'status': status,
      };

  Map<String, dynamic> toJson() => _$ReportOwnerToJson(this);

  ReportOwner copyWith({
    String? playerId,
    int? status,
  }) {
    return ReportOwner(
      playerId: playerId ?? this.playerId,
      status: status ?? this.status,
    );
  }
}

extension ListOwners on List<ReportOwner> {
  ReportOwner? findById(String playerId) {
    return firstWhere((owner) => owner.playerId == playerId);
  }

  int getOwnerIndex(String playerId) =>
      indexWhere((owner) => owner.playerId == playerId);

  int getReportStatus(String playerId) =>
      firstWhere((owner) => owner.playerId == playerId).status;
}
