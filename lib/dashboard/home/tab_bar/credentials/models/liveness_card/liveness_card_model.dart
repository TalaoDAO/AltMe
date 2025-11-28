import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/tezotopia_voucher/offers.dart';
import 'package:json_annotation/json_annotation.dart';

part 'liveness_card_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LivenessCardModel extends CredentialSubjectModel {
  LivenessCardModel({
    this.expires,
    this.offers,
    super.id,
    super.type,
    super.issuedBy,
    super.offeredBy,
  }) : super(
         credentialSubjectType: CredentialSubjectType.livenessCard,
         credentialCategory: CredentialCategory.identityCards,
       );

  factory LivenessCardModel.fromJson(Map<String, dynamic> json) =>
      _$LivenessCardModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? expires;
  final Offers? offers;

  @override
  Map<String, dynamic> toJson() => _$LivenessCardModelToJson(this);
}
