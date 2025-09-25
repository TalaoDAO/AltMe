// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_manifest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialManifest _$CredentialManifestFromJson(Map<String, dynamic> json) =>
    CredentialManifest(
      json['id'] as String?,
      json['issuer'] == null
          ? null
          : IssuedBy.fromJson(json['issuer'] as Map<String, dynamic>),
      (json['output_descriptors'] as List<dynamic>?)
          ?.map((e) => OutputDescriptor.fromJson(e as Map<String, dynamic>))
          .toList(),
      CredentialManifest.presentationDefinitionFromJson(
        json['presentation_definition'],
      ),
    );

Map<String, dynamic> _$CredentialManifestToJson(CredentialManifest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'issuer': instance.issuedBy?.toJson(),
      'output_descriptors': instance.outputDescriptors
          ?.map((e) => e.toJson())
          .toList(),
      'presentation_definition': instance.presentationDefinition?.toJson(),
    };
