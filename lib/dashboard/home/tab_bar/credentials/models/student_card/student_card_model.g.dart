// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentCardModel _$StudentCardModelFromJson(Map<String, dynamic> json) =>
    StudentCardModel(
      recipient: StudentCardModel._fromJsonProfessionalStudentCardRecipient(
          json['recipient']),
      expires: json['expires'] as String? ?? '',
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$StudentCardModelToJson(StudentCardModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'type': instance.type,
    'issuedBy': instance.issuedBy?.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('offeredBy', instance.offeredBy?.toJson());
  val['recipient'] = instance.recipient?.toJson();
  val['expires'] = instance.expires;
  return val;
}
