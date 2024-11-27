// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'polygon_associated_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PolygonAssociatedAddressModel _$PolygonAssociatedAddressModelFromJson(
        Map<String, dynamic> json) =>
    PolygonAssociatedAddressModel(
      associatedAddress: json['associatedAddress'] as String? ?? '',
      id: json['id'] as String,
      type: json['type'] as String,
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
    );

Map<String, dynamic> _$PolygonAssociatedAddressModelToJson(
        PolygonAssociatedAddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      'associatedAddress': instance.associatedAddress,
    };
