import 'package:altme/activity_log/activity_log.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'log_class.g.dart';

@JsonSerializable()
class LogData extends Equatable {
  const LogData({
    required this.type,
    required this.timestamp,
    this.credentialId,
    this.data,
  });

  factory LogData.fromJson(Map<String, dynamic> json) =>
      _$LogDataFromJson(json);

  final LogType type;
  final DateTime timestamp;
  final String? credentialId;
  final String? data;

  Map<String, dynamic> toJson() => _$LogDataToJson(this);

  @override
  List<Object?> get props => [
        type,
        timestamp,
        credentialId,
        data,
      ];
}
