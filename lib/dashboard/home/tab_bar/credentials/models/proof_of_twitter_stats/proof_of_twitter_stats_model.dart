import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'proof_of_twitter_stats_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProofOfTwitterStatsModel extends CredentialSubjectModel {
  ProofOfTwitterStatsModel({
    super.id,
    super.type,
    super.issuedBy,
    super.offeredBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.proofOfTwitterStats,
          credentialCategory: CredentialCategory.polygonidCards,
        );

  factory ProofOfTwitterStatsModel.fromJson(Map<String, dynamic> json) =>
      _$ProofOfTwitterStatsModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProofOfTwitterStatsModelToJson(this);
}
