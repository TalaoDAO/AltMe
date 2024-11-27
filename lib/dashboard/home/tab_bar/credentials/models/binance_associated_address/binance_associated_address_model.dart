import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'binance_associated_address_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BinanceAssociatedAddressModel extends CredentialSubjectModel {
  BinanceAssociatedAddressModel({
    this.associatedAddress,
    required String super.id,
    required String super.type,
    required Author super.issuedBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.binanceAssociatedWallet,
          credentialCategory: CredentialCategory.blockchainAccountsCards,
        );

  factory BinanceAssociatedAddressModel.fromJson(Map<String, dynamic> json) =>
      _$BinanceAssociatedAddressModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? associatedAddress;

  @override
  Map<String, dynamic> toJson() => _$BinanceAssociatedAddressModelToJson(this);
}
