// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selective_disclosure_pick_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectiveDisclosureState _$SelectiveDisclosureStateFromJson(
        Map<String, dynamic> json) =>
    SelectiveDisclosureState(
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      selectedClaimsKeyIds: (json['selectedClaimsKeyIds'] as List<dynamic>?)
              ?.map((e) =>
                  SelectedClaimsKeyIds.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      selectedSDIndexInJWT: (json['selectedSDIndexInJWT'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      limitDisclosure: json['limitDisclosure'] as String?,
      filters: json['filters'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$SelectiveDisclosureStateToJson(
        SelectiveDisclosureState instance) =>
    <String, dynamic>{
      'message': instance.message,
      'selectedClaimsKeyIds': instance.selectedClaimsKeyIds,
      'selectedSDIndexInJWT': instance.selectedSDIndexInJWT,
      'limitDisclosure': instance.limitDisclosure,
      'filters': instance.filters,
    };

SelectedClaimsKeyIds _$SelectedClaimsKeyIdsFromJson(
        Map<String, dynamic> json) =>
    SelectedClaimsKeyIds(
      keyId: json['keyId'] as String,
      isSelected: json['isSelected'] as bool,
    );

Map<String, dynamic> _$SelectedClaimsKeyIdsToJson(
        SelectedClaimsKeyIds instance) =>
    <String, dynamic>{
      'keyId': instance.keyId,
      'isSelected': instance.isSelected,
    };
