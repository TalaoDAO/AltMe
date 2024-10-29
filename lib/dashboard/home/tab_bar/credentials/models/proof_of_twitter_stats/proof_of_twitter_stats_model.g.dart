// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proof_of_twitter_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProofOfTwitterStatsModel _$ProofOfTwitterStatsModelFromJson(
        Map<String, dynamic> json) =>
    ProofOfTwitterStatsModel(
      id: json['id'] as String?,
      type: json['type'] as String?,
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$ProofOfTwitterStatsModelToJson(
    ProofOfTwitterStatsModel instance) {
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
  return val;
}
