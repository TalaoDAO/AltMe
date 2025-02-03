// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oidc4vci_stack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Oidc4VCIStack _$Oidc4VCIStackFromJson(Map<String, dynamic> json) =>
    Oidc4VCIStack(
      stack: (json['stack'] as List<dynamic>?)
              ?.map((e) => Oidc4VCIState.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Oidc4VCIState>[],
    );

Map<String, dynamic> _$Oidc4VCIStackToJson(Oidc4VCIStack instance) =>
    <String, dynamic>{
      'stack': instance.stack.map((e) => e.toJson()).toList(),
    };
