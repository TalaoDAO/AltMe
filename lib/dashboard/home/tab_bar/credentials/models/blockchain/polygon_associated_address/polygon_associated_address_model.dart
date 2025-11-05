import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/blockchain/blockchain_credential_subject_model/blockchain_credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class PolygonAssociatedAddressModel extends BlockchainCredentialSubjectModel {
  PolygonAssociatedAddressModel({
    super.associatedAddress,
    required super.id,
    required super.type,
    super.issuedBy,
    super.offeredBy,
  }) : super(
         credentialSubjectType: CredentialSubjectType.polygonAssociatedWallet,
         credentialCategory: CredentialCategory.blockchainAccountsCards,
       );

}
