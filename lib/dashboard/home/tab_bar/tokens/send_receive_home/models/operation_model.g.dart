// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperationModel _$OperationModelFromJson(Map<String, dynamic> json) =>
    OperationModel(
      type: json['type'] as String,
      id: (json['id'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      timestamp: json['timestamp'] as String,
      block: json['block'] as String,
      hash: json['hash'] as String,
      counter: (json['counter'] as num).toInt(),
      sender: OperationAddressModel.fromJson(
          json['sender'] as Map<String, dynamic>),
      gasLimit: (json['gasLimit'] as num).toInt(),
      gasUsed: (json['gasUsed'] as num).toInt(),
      storageLimit: (json['storageLimit'] as num).toInt(),
      storageUsed: (json['storageUsed'] as num).toInt(),
      bakerFee: (json['bakerFee'] as num).toInt(),
      storageFee: (json['storageFee'] as num).toInt(),
      allocationFee: (json['allocationFee'] as num).toInt(),
      target: OperationAddressModel.fromJson(
          json['target'] as Map<String, dynamic>),
      amount: json['amount'],
      status: json['status'] as String,
      hasInternals: json['hasInternals'] as bool,
      parameter: json['parameter'] == null
          ? null
          : OperationParameterModel.fromJson(
              json['parameter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OperationModelToJson(OperationModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'level': instance.level,
      'timestamp': instance.timestamp,
      'block': instance.block,
      'hash': instance.hash,
      'counter': instance.counter,
      'sender': instance.sender,
      'gasLimit': instance.gasLimit,
      'gasUsed': instance.gasUsed,
      'storageLimit': instance.storageLimit,
      'storageUsed': instance.storageUsed,
      'bakerFee': instance.bakerFee,
      'storageFee': instance.storageFee,
      'allocationFee': instance.allocationFee,
      'target': instance.target,
      'amount': instance.amount,
      'status': instance.status,
      'hasInternals': instance.hasInternals,
      'parameter': instance.parameter,
    };
