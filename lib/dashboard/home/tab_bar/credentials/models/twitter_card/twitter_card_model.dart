import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'twitter_card_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TwitterCardModel extends CredentialSubjectModel {
  TwitterCardModel({
    super.id,
    super.type,
    super.issuedBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.twitterCard,
          credentialCategory: CredentialCategory.identityCards,
        );

  factory TwitterCardModel.fromJson(Map<String, dynamic> json) =>
      _$TwitterCardModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TwitterCardModelToJson(this);
}
