// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twitter_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TwitterCardModel _$TwitterCardModelFromJson(Map<String, dynamic> json) =>
    TwitterCardModel(
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$TwitterCardModelToJson(TwitterCardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
    };
