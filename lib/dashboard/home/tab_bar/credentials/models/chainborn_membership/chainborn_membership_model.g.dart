// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chainborn_membership_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChainbornMembershipModel _$ChainbornMembershipModelFromJson(
        Map<String, dynamic> json) =>
    ChainbornMembershipModel(
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$ChainbornMembershipModelToJson(
        ChainbornMembershipModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
    };
