import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/tezotopia_voucher/offers.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tezotopia_voucher_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TezotopiaVoucherModel extends CredentialSubjectModel {
  TezotopiaVoucherModel({
    super.id,
    super.type,
    super.issuedBy,
    this.identifier,
    this.offers,
  }) : super(
          credentialSubjectType: CredentialSubjectType.tezVoucher,
          credentialCategory: CredentialCategory.gamingCards,
        );

  factory TezotopiaVoucherModel.fromJson(Map<String, dynamic> json) =>
      _$TezotopiaVoucherModelFromJson(json);

  final Offers? offers;

  @JsonKey(defaultValue: '')
  final String? identifier;

  @override
  Map<String, dynamic> toJson() => _$TezotopiaVoucherModelToJson(this);
}
