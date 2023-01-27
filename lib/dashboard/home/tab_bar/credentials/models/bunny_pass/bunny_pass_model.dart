import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/tezotopia_voucher/offers.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bunny_pass_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BunnyPassModel extends CredentialSubjectModel {
  BunnyPassModel({
    this.expires,
    this.offers,
    super.id,
    super.type,
    super.issuedBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.bunnyPass,
          credentialCategory: CredentialCategory.gamingCards,
        );

  factory BunnyPassModel.fromJson(Map<String, dynamic> json) =>
      _$BunnyPassModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? expires;
  final Offers? offers;

  @override
  Map<String, dynamic> toJson() => _$BunnyPassModelToJson(this);
}
