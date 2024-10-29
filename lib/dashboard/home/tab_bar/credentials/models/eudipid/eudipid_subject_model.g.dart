// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eudipid_subject_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EudipidSubjectModel _$EudipidSubjectModelFromJson(Map<String, dynamic> json) =>
    EudipidSubjectModel(
      id: json['id'] as String?,
      type: json['type'] as String?,
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
    );

Map<String, dynamic> _$EudipidSubjectModelToJson(
        EudipidSubjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
    };
