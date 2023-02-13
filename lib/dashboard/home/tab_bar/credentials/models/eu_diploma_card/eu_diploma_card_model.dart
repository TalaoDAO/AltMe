import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'eu_diploma_card_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EUDiplomaCardModel extends CredentialSubjectModel {
  EUDiplomaCardModel({
    this.expires,
    super.id,
    super.type,
    super.issuedBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.euDiplomaCard,
          credentialCategory: CredentialCategory.othersCards,
        );

  factory EUDiplomaCardModel.fromJson(Map<String, dynamic> json) =>
      _$EUDiplomaCardModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? expires;

  @override
  Map<String, dynamic> toJson() => _$EUDiplomaCardModelToJson(this);
}
