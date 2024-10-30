// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'polygon_associated_address_credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PolygonAssociatedAddressCredential _$PolygonAssociatedAddressCredentialFromJson(
        Map<String, dynamic> json) =>
    PolygonAssociatedAddressCredential(
      id: json['id'] as String,
      issuer: json['issuer'] as String,
      issuanceDate: json['issuanceDate'] as String,
      credentialSubjectModel: CredentialSubjectModel.fromJson(
          json['credentialSubject'] as Map<String, dynamic>),
      context: json['@context'] as List<dynamic>? ??
          [
            'https://www.w3.org/2018/credentials/v1',
            {
              'PolygonAssociatedAddress': {
                '@id':
                    'https://github.com/TalaoDAO/context#polygonassociatedaddress',
                '@context': {
                  '@version': 1.1,
                  '@protected': true,
                  'id': '@id',
                  'type': '@type',
                  'schema': 'https://schema.org/',
                  'accountName': 'schema:identifier',
                  'associatedAddress': 'schema:account',
                  'cryptoWalletSignature': 'schema:identifier',
                  'cryptoWalletPayload': 'schema:identifier',
                  'issuedBy': {
                    '@id': 'schema:issuedBy',
                    '@context': {
                      '@version': 1.1,
                      '@protected': true,
                      'schema': 'https://schema.org/',
                      'name': 'schema:legalName'
                    }
                  }
                }
              }
            }
          ],
      type:
          (json['type'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              ['VerifiableCredential', 'PolygonAssociatedAddress'],
    );

Map<String, dynamic> _$PolygonAssociatedAddressCredentialToJson(
        PolygonAssociatedAddressCredential instance) =>
    <String, dynamic>{
      '@context': instance.context,
      'id': instance.id,
      'type': instance.type,
      'credentialSubject': instance.credentialSubjectModel.toJson(),
      'issuer': instance.issuer,
      'issuanceDate': instance.issuanceDate,
    };
