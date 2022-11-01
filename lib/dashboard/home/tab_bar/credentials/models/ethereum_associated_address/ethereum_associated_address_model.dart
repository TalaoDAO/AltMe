import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ethereum_associated_address_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EthereumAssociatedAddressModel extends CredentialSubjectModel {
  EthereumAssociatedAddressModel({
    this.associatedAddress,
    this.accountName,
    String? id,
    String? type,
  }) : super(
          id: id,
          type: type,
          credentialSubjectType: CredentialSubjectType.tezosAssociatedWallet,
          credentialCategory: CredentialCategory.proofOfOwnershipCards,
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
