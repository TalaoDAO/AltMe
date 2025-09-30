// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogData _$LogDataFromJson(Map<String, dynamic> json) => LogData(
      type: $enumDecode(_$LogTypeEnumMap, json['type']),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      vcInfo: json['vcInfo'] == null
          ? null
          : VCInfo.fromJson(json['vcInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LogDataToJson(LogData instance) => <String, dynamic>{
      'type': _$LogTypeEnumMap[instance.type]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'vcInfo': instance.vcInfo,
    };

const _$LogTypeEnumMap = {
  LogType.walletInit: 'walletInit',
  LogType.backupData: 'backupData',
  LogType.restoreWallet: 'restoreWallet',
  LogType.addVC: 'addVC',
  LogType.deleteVC: 'deleteVC',
  LogType.presentVC: 'presentVC',
  LogType.importKey: 'importKey',
};

VCInfo _$VCInfoFromJson(Map<String, dynamic> json) => VCInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      domain: json['domain'] as String?,
    );

Map<String, dynamic> _$VCInfoToJson(VCInfo instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'domain': instance.domain,
    };
