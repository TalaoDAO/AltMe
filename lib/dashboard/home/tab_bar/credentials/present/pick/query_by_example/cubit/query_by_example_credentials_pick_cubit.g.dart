// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_by_example_credentials_pick_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryByExampleCredentialPickState _$QueryByExampleCredentialPickStateFromJson(
  Map<String, dynamic> json,
) => QueryByExampleCredentialPickState(
  selected: (json['selected'] as num?)?.toInt(),
  filteredCredentialList: (json['filteredCredentialList'] as List<dynamic>)
      .map((e) => CredentialModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QueryByExampleCredentialPickStateToJson(
  QueryByExampleCredentialPickState instance,
) => <String, dynamic>{
  'selected': instance.selected,
  'filteredCredentialList': instance.filteredCredentialList,
};
