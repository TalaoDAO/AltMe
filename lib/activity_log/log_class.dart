import 'package:altme/activity_log/activity_log.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'log_class.g.dart';

@JsonSerializable()
class LogData extends Equatable {
  LogData({
    required this.type,
    DateTime? timestamp,
    this.vcInfo,
  }) : timestamp = timestamp ?? DateTime.now();

  factory LogData.fromJson(Map<String, dynamic> json) =>
      _$LogDataFromJson(json);

  final LogType type;
  final DateTime timestamp;
  final VCInfo? vcInfo;

  Map<String, dynamic> toJson() => _$LogDataToJson(this);

  @override
  List<Object?> get props => [
        type,
        timestamp,
        vcInfo,
      ];
}

@JsonSerializable()
class VCInfo extends Equatable {
  const VCInfo({
    required this.id,
    required this.name,
    this.domain,
  });

  factory VCInfo.fromJson(Map<String, dynamic> json) => _$VCInfoFromJson(json);

  final String id;
  final String name;
  final String? domain;

  Map<String, dynamic> toJson() => _$VCInfoToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        domain,
      ];
}
