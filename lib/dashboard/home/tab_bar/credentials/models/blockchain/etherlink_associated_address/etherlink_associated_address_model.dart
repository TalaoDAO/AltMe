import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/blockchain/blockchain_credential_subject_model/blockchain_credential_subject_model.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'etherlink_associated_address_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EtherlinkAssociatedAddressModel extends BlockchainCredentialSubjectModel {
  EtherlinkAssociatedAddressModel({
    super.associatedAddress,
    required super.id,
    required super.type,
    super.issuedBy,
    super.offeredBy,
  }) : super(
         credentialSubjectType: CredentialSubjectType.etherlinkAssociatedWallet,
         credentialCategory: CredentialCategory.blockchainAccountsCards,
       );

  factory EtherlinkAssociatedAddressModel.fromJson(Map<String, dynamic> json) =>
      _$EtherlinkAssociatedAddressModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$EtherlinkAssociatedAddressModelToJson(this);
}
