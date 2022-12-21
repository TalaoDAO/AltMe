import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'binance_associated_address_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BinanceAssociatedAddressModel extends CredentialSubjectModel {
  BinanceAssociatedAddressModel({
    this.associatedAddress,
    this.accountName,
    required String id,
  }) : super(
          id: id,
          type: 'BinanceAssociatedAddress',
          credentialSubjectType: CredentialSubjectType.binanceAssociatedWallet,
          credentialCategory: CredentialCategory.blockchainAccountsCards,
          issuedBy: const Author('My Wallet', null),
        );

  factory BinanceAssociatedAddressModel.fromJson(Map<String, dynamic> json) =>
      _$BinanceAssociatedAddressModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? associatedAddress;

  @JsonKey(defaultValue: '')
  final String? accountName;

  @override
  Map<String, dynamic> toJson() => _$BinanceAssociatedAddressModelToJson(this);
}
