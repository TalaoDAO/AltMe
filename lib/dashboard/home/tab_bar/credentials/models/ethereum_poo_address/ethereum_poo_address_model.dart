import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ethereum_poo_address_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EthereumPooAddressModel extends CredentialSubjectModel {
  EthereumPooAddressModel({
    this.associatedAddress,
    super.id,
    super.type,
    super.issuedBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.ethereumPooAddress,
          credentialCategory: CredentialCategory.blockchainAccountsCards,
        );

  factory EthereumPooAddressModel.fromJson(Map<String, dynamic> json) =>
      _$EthereumPooAddressModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? associatedAddress;

  @override
  Map<String, dynamic> toJson() => _$EthereumPooAddressModelToJson(this);
}
