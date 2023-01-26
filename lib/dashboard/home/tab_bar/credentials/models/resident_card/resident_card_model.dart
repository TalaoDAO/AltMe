import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'resident_card_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResidentCardModel extends CredentialSubjectModel {
  ResidentCardModel({
    super.id,
    this.gender,
    this.maritalStatus,
    super.type,
    this.birthPlace,
    this.nationality,
    this.address,
    this.identifier,
    this.familyName,
    this.image,
    super.issuedBy,
    this.birthDate,
    this.givenName,
  }) : super(
          credentialSubjectType: CredentialSubjectType.residentCard,
          credentialCategory: CredentialCategory.communityCards,
        );

  factory ResidentCardModel.fromJson(Map<String, dynamic> json) =>
      _$ResidentCardModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? gender;
  @JsonKey(defaultValue: '')
  final String? maritalStatus;
  @JsonKey(defaultValue: '')
  final String? birthPlace;
  @JsonKey(defaultValue: '')
  final String? nationality;
  @JsonKey(defaultValue: '')
  final String? address;
  @JsonKey(defaultValue: '')
  final String? identifier;
  @JsonKey(defaultValue: '')
  final String? familyName;
  @JsonKey(defaultValue: '')
  final String? image;
  @JsonKey(defaultValue: '')
  final String? birthDate;
  @JsonKey(defaultValue: '')
  final String? givenName;

  @override
  Map<String, dynamic> toJson() => _$ResidentCardModelToJson(this);
}
