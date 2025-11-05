import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/blockchain/blockchain_credential_subject_model/blockchain_credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'binance_associated_address_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BinanceAssociatedAddressModel extends BlockchainCredentialSubjectModel {
  BinanceAssociatedAddressModel({
    super.associatedAddress,
    required super.id,
    required super.type,
  }) : super(
         credentialSubjectType: CredentialSubjectType.binanceAssociatedWallet,
         credentialCategory: CredentialCategory.blockchainAccountsCards,
       );

  factory BinanceAssociatedAddressModel.fromJson(Map<String, dynamic> json) =>
      _$BinanceAssociatedAddressModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BinanceAssociatedAddressModelToJson(this);
}
