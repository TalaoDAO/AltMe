import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/tezotopia_voucher/offers.dart';
import 'package:json_annotation/json_annotation.dart';

part 'troopez_pass_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TroopezPassModel extends CredentialSubjectModel {
  TroopezPassModel({
    this.expires,
    this.offers,
    String? id,
    String? type,
    Author? issuedBy,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
          credentialSubjectType: CredentialSubjectType.troopezPass,
          credentialCategory: CredentialCategory.gamingCards,
        );

  factory TroopezPassModel.fromJson(Map<String, dynamic> json) =>
      _$TroopezPassModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? expires;
  final Offers? offers;

  @override
  Map<String, dynamic> toJson() => _$TroopezPassModelToJson(this);
}
