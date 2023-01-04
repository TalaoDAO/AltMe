import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/author/author.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'diploma_card_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DiplomaCardModel extends CredentialSubjectModel {
  DiplomaCardModel({
    this.familyName,
    this.givenName,
    this.programName,
    String? id,
    String? type,
    Author? issuedBy,
    this.identifier,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
          credentialSubjectType: CredentialSubjectType.diplomaCard,
          credentialCategory: CredentialCategory.myProfessionalCards,
        );

  factory DiplomaCardModel.fromJson(Map<String, dynamic> json) =>
      _$DiplomaCardModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? identifier;
  @JsonKey(defaultValue: '')
  String? familyName;
  @JsonKey(defaultValue: '')
  String? givenName;
  @JsonKey(defaultValue: '')
  String? programName;

  @override
  Map<String, dynamic> toJson() => _$DiplomaCardModelToJson(this);
}
