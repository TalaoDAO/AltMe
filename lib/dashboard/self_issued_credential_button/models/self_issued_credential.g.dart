// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'self_issued_credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelfIssuedCredential _$SelfIssuedCredentialFromJson(
        Map<String, dynamic> json) =>
    SelfIssuedCredential(
      id: json['id'] as String,
      issuer: json['issuer'] as String,
      issuanceDate: json['issuanceDate'] as String,
      credentialSubjectModel: CredentialSubjectModel.fromJson(
          json['credentialSubject'] as Map<String, dynamic>),
      context: json['@context'] as List<dynamic>? ??
          [
            'https://www.w3.org/2018/credentials/v1',
            {
              'name': 'https://schema.org/name',
              'description': 'https://schema.org/description',
              'SelfIssued': {
                '@context': {
                  '@protected': true,
                  '@version': 1.1,
                  'address': 'schema:address',
                  'email': 'schema:email',
                  'familyName': 'schema:familyName',
                  'givenName': 'scheama:givenName',
                  'jobTitle': 'schema:jobTitle',
                  'workFor': 'schema:workFor',
                  'companyWebsite': 'schema:website',
                  'id': '@id',
                  'schema': 'https://schema.org/',
                  'telephone': 'schema:telephone',
                  'type': '@type'
                },
                '@id': 'https://github.com/TalaoDAO/context/blob/main/README.md'
              }
            }
          ],
      type:
          (json['type'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              ['VerifiableCredential', 'SelfIssued'],
      name: json['name'] as List<dynamic>? ??
          [
            {'@language': 'en', '@value': 'Self Issued credential'},
            {'@language': 'de', '@value': ''},
            {'@language': 'fr', '@value': 'Attestation déclarative'}
          ],
      description: json['description'] as List<dynamic>? ??
          [
            {
              '@language': 'en',
              '@value':
                  'This signed electronic certificate has been issued by the user itself.'
            },
            {'@language': 'de', '@value': ''},
            {
              '@language': 'fr',
              '@value':
                  "Cette attestation électronique est signée par l'utilisateur."
            }
          ],
    );

Map<String, dynamic> _$SelfIssuedCredentialToJson(
        SelfIssuedCredential instance) =>
    <String, dynamic>{
      '@context': instance.context,
      'id': instance.id,
      'type': instance.type,
      'credentialSubject': instance.credentialSubjectModel.toJson(),
      'issuer': instance.issuer,
      'issuanceDate': instance.issuanceDate,
      'description': instance.description,
      'name': instance.name,
    };
