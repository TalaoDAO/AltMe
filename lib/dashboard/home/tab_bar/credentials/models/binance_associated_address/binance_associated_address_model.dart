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
    required String type,
    required Author issuedBy,
  }) : super(
          id: id,
          type: type,
          credentialSubjectType: CredentialSubjectType.binanceAssociatedWallet,
          credentialCategory: CredentialCategory.blockchainAccountsCards,
          issuedBy: issuedBy,
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
