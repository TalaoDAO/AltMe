// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Offers _$OffersFromJson(Map<String, dynamic> json) => Offers(
  benefit: json['benefit'] == null
      ? null
      : Benefit.fromJson(json['benefit'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OffersToJson(Offers instance) => <String, dynamic>{
  'benefit': instance.benefit?.toJson(),
};
