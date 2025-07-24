// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postal_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostalAddress _$PostalAddressFromJson(Map<String, dynamic> json) =>
    PostalAddress(
      streetAddress: json['streetAddress'] as String?,
      locality: json['locality'] as String?,
      postalCode: json['postalCode'] as String?,
      countryName: json['countryName'] as String?,
    );

Map<String, dynamic> _$PostalAddressToJson(PostalAddress instance) =>
    <String, dynamic>{
      'streetAddress': instance.streetAddress,
      'locality': instance.locality,
      'postalCode': instance.postalCode,
      'countryName': instance.countryName,
    };
