import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/blockchain/blockchain_credential_subject_model/blockchain_credential_subject_model.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tezos_associated_address_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TezosAssociatedAddressModel extends BlockchainCredentialSubjectModel {
  TezosAssociatedAddressModel({
    super.associatedAddress,
    required super.id,
    required super.type,
    super.issuedBy,
    super.offeredBy,
  }) : super(
         credentialSubjectType: CredentialSubjectType.tezosAssociatedWallet,
         credentialCategory: CredentialCategory.blockchainAccountsCards,
       );

  factory TezosAssociatedAddressModel.fromJson(Map<String, dynamic> json) =>
      _$TezosAssociatedAddressModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TezosAssociatedAddressModelToJson(this);
}
