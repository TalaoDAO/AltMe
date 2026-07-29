// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fantom_associated_address_credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FantomAssociatedAddressCredential _$FantomAssociatedAddressCredentialFromJson(
  Map<String, dynamic> json,
) => FantomAssociatedAddressCredential(
  id: json['id'] as String,
  issuer: json['issuer'] as String,
  issuanceDate: json['issuanceDate'] as String,
  credentialSubjectModel: CredentialSubjectModel.fromJson(
    json['credentialSubject'] as Map<String, dynamic>,
  ),
  context:
      json['@context'] as List<dynamic>? ??
      [
        'https://www.w3.org/2018/credentials/v1',
        {
          '@vocab': 'https://schema.org',
          'associatedAddress': 'https://w3id.org/security#blockchainAccountId',
          'FantomAssociatedAddress':
              'https://doc.wallet-provider.io/vc_type/#FantomAssociatedAdress',
        },
      ],
  type:
      (json['type'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      ['VerifiableCredential', 'FantomAssociatedAddress'],
);

Map<String, dynamic> _$FantomAssociatedAddressCredentialToJson(
  FantomAssociatedAddressCredential instance,
) => <String, dynamic>{
  '@context': instance.context,
  'id': instance.id,
  'type': instance.type,
  'credentialSubject': instance.credentialSubjectModel.toJson(),
  'issuer': instance.issuer,
  'issuanceDate': instance.issuanceDate,
};
