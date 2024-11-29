// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'etherlink_associated_address_credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EtherlinkAssociatedAddressCredential
    _$EtherlinkAssociatedAddressCredentialFromJson(Map<String, dynamic> json) =>
        EtherlinkAssociatedAddressCredential(
          id: json['id'] as String,
          issuer: json['issuer'] as String,
          issuanceDate: json['issuanceDate'] as String,
          credentialSubjectModel: CredentialSubjectModel.fromJson(
              json['credentialSubject'] as Map<String, dynamic>),
          context: json['@context'] as List<dynamic>? ??
              [
                'https://www.w3.org/2018/credentials/v1',
                {
                  '@vocab': 'https://schema.org',
                  'associatedAddress':
                      'https://w3id.org/security#blockchainAccountId',
                  'EtherlinkAssociatedAddress':
                      'https://doc.wallet-provider.io/vc_type/#EtherlinkAssociatedAdress'
                }
              ],
          type: (json['type'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              ['VerifiableCredential', 'EtherlinkAssociatedAddress'],
        );

Map<String, dynamic> _$EtherlinkAssociatedAddressCredentialToJson(
        EtherlinkAssociatedAddressCredential instance) =>
    <String, dynamic>{
      '@context': instance.context,
      'id': instance.id,
      'type': instance.type,
      'credentialSubject': instance.credentialSubjectModel.toJson(),
      'issuer': instance.issuer,
      'issuanceDate': instance.issuanceDate,
    };
