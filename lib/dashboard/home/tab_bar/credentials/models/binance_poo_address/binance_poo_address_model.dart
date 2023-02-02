import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'binance_poo_address_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BinancePooAddressModel extends CredentialSubjectModel {
  BinancePooAddressModel({
    this.associatedAddress,
    super.id,
    super.type,
    super.issuedBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.binancePooAddress,
          credentialCategory: CredentialCategory.blockchainAccountsCards,
        );

  factory BinancePooAddressModel.fromJson(Map<String, dynamic> json) =>
      _$BinancePooAddressModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? associatedAddress;

  @override
  Map<String, dynamic> toJson() => _$BinancePooAddressModelToJson(this);
}
