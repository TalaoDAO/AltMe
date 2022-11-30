import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/tezotopia_voucher/offers.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pigs_pass_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PigsPassModel extends CredentialSubjectModel {
  PigsPassModel({
    this.expires,
    this.offers,
    String? id,
    String? type,
    Author? issuedBy,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
          credentialSubjectType: CredentialSubjectType.pigsPass,
          credentialCategory: CredentialCategory.gamingCards,
        );

  factory PigsPassModel.fromJson(Map<String, dynamic> json) =>
      _$PigsPassModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? expires;
  final Offers? offers;

  @override
  Map<String, dynamic> toJson() => _$PigsPassModelToJson(this);
}
