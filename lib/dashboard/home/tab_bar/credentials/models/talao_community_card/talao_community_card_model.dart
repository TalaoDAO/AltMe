import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'talao_community_card_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TalaoCommunityCardModel extends CredentialSubjectModel {
  TalaoCommunityCardModel({
    super.id,
    super.type,
    super.issuedBy,
    this.identifier,
  }) : super(
          credentialSubjectType: CredentialSubjectType.talaoCommunityCard,
          credentialCategory: CredentialCategory.communityCards,
        );

  factory TalaoCommunityCardModel.fromJson(Map<String, dynamic> json) =>
      _$TalaoCommunityCardModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? identifier;

  @override
  Map<String, dynamic> toJson() => _$TalaoCommunityCardModelToJson(this);
}
