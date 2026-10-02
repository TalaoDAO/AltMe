// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CryptoAccount _$CryptoAccountFromJson(Map<String, dynamic> json) =>
    CryptoAccount(
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (e) => CryptoAccountData.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CryptoAccountToJson(CryptoAccount instance) =>
    <String, dynamic>{'data': instance.data};
