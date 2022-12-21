import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ethereum_associated_address_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EthereumAssociatedAddressModel extends CredentialSubjectModel {
  EthereumAssociatedAddressModel({
    this.associatedAddress,
    this.accountName,
    required String id,
  }) : super(
          id: id,
          type: 'EthereumAssociatedAddress',
          credentialSubjectType: CredentialSubjectType.ethereumAssociatedWallet,
          credentialCategory: CredentialCategory.blockchainAccountsCards,
          issuedBy: const Author('My Wallet', null),
        );

  factory EthereumAssociatedAddressModel.fromJson(Map<String, dynamic> json) =>
      _$EthereumAssociatedAddressModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? associatedAddress;

  @JsonKey(defaultValue: '')
  final String? accountName;

  @override
  Map<String, dynamic> toJson() => _$EthereumAssociatedAddressModelToJson(this);
}
