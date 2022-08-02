import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/author/author.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'talao_community_card_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TalaoCommunityCardModel extends CredentialSubjectModel {
  TalaoCommunityCardModel({
    String? id,
    String? type,
    Author? issuedBy,
    this.identifier,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
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
