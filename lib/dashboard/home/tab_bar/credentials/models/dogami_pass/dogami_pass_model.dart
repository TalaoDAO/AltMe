import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/tezotopia_voucher/offers.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dogami_pass_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DogamiPassModel extends CredentialSubjectModel {
  DogamiPassModel({
    this.expires,
    this.offers,
    String? id,
    String? type,
    Author? issuedBy,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
          credentialSubjectType: CredentialSubjectType.dogamiPass,
          credentialCategory: CredentialCategory.gamingCards,
        );

  factory DogamiPassModel.fromJson(Map<String, dynamic> json) =>
      _$DogamiPassModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? expires;
  final Offers? offers;

  @override
  Map<String, dynamic> toJson() => _$DogamiPassModelToJson(this);
}
