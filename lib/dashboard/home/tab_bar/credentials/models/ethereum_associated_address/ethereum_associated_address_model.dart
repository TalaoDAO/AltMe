import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ethereum_associated_address_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EthereumAssociatedAddressModel extends CredentialSubjectModel {
  EthereumAssociatedAddressModel({
    this.associatedAddress,
    required String super.id,
    required String super.type,
    required Author super.issuedBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.ethereumAssociatedWallet,
          credentialCategory: CredentialCategory.blockchainAccountsCards,
        );

  factory EthereumAssociatedAddressModel.fromJson(Map<String, dynamic> json) =>
      _$EthereumAssociatedAddressModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? associatedAddress;

  @override
  Map<String, dynamic> toJson() => _$EthereumAssociatedAddressModelToJson(this);
}
