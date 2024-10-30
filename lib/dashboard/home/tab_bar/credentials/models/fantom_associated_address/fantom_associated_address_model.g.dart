// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fantom_associated_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FantomAssociatedAddressModel _$FantomAssociatedAddressModelFromJson(
        Map<String, dynamic> json) =>
    FantomAssociatedAddressModel(
      associatedAddress: json['associatedAddress'] as String? ?? '',
      accountName: json['accountName'] as String? ?? '',
      id: json['id'] as String,
      type: json['type'] as String,
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
    );

Map<String, dynamic> _$FantomAssociatedAddressModelToJson(
        FantomAssociatedAddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      'associatedAddress': instance.associatedAddress,
      'accountName': instance.accountName,
    };
