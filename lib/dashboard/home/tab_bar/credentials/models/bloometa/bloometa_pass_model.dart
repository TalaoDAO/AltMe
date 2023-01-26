import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/tezotopia_voucher/offers.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bloometa_pass_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BloometaPassModel extends CredentialSubjectModel {
  BloometaPassModel({
    this.expires,
    this.offers,
    super.id,
    super.type,
    super.issuedBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.bloometaPass,
          credentialCategory: CredentialCategory.gamingCards,
        );

  factory BloometaPassModel.fromJson(Map<String, dynamic> json) =>
      _$BloometaPassModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? expires;
  final Offers? offers;

  @override
  Map<String, dynamic> toJson() => _$BloometaPassModelToJson(this);
}
