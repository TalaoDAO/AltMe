// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pid_subject_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PidSubjectModel _$PidSubjectModelFromJson(Map<String, dynamic> json) =>
    PidSubjectModel(
      id: json['id'] as String?,
      type: json['type'] as String?,
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
    );

Map<String, dynamic> _$PidSubjectModelToJson(PidSubjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
    };
