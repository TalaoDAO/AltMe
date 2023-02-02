import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/tezotopia_voucher/offers.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tezotopia_membership_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TezotopiaMembershipModel extends CredentialSubjectModel {
  TezotopiaMembershipModel({
    this.expires,
    this.offers,
    super.id,
    super.type,
    super.issuedBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.tezotopiaMembership,
          credentialCategory: CredentialCategory.gamingCards,
        );

  factory TezotopiaMembershipModel.fromJson(Map<String, dynamic> json) =>
      _$TezotopiaMembershipModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? expires;
  final Offers? offers;

  @override
  Map<String, dynamic> toJson() => _$TezotopiaMembershipModelToJson(this);
}
