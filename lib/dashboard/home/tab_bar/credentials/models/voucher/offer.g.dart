// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Offer _$OfferFromJson(Map<String, dynamic> json) => Offer(
      json['value'] as String? ?? '',
      json['currency'] as String? ?? '',
    );

Map<String, dynamic> _$OfferToJson(Offer instance) => <String, dynamic>{
      'value': instance.value,
      'currency': instance.currency,
    };
