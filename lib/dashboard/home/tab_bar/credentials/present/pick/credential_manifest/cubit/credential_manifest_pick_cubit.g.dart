// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_manifest_pick_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialManifestPickState _$CredentialManifestPickStateFromJson(
        Map<String, dynamic> json) =>
    CredentialManifestPickState(
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      selected: (json['selected'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      filteredCredentialList: (json['filteredCredentialList'] as List<dynamic>)
          .map((e) => CredentialModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      presentationDefinition: json['presentationDefinition'] == null
          ? null
          : PresentationDefinition.fromJson(
              json['presentationDefinition'] as Map<String, dynamic>),
      isButtonEnabled: json['isButtonEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$CredentialManifestPickStateToJson(
        CredentialManifestPickState instance) =>
    <String, dynamic>{
      'message': instance.message,
      'selected': instance.selected,
      'filteredCredentialList': instance.filteredCredentialList,
      'presentationDefinition': instance.presentationDefinition,
      'isButtonEnabled': instance.isButtonEnabled,
    };
