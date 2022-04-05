// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encryption.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Encryption _$EncryptionFromJson(Map<String, dynamic> json) => Encryption(
      cipherText: json['cipherText'] as String?,
      authenticationTag: json['authenticationTag'] as String?,
    );

Map<String, dynamic> _$EncryptionToJson(Encryption instance) =>
    <String, dynamic>{
      'cipherText': instance.cipherText,
      'authenticationTag': instance.authenticationTag,
    };
