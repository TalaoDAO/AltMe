import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/blockchain/blockchain_credential_subject_model/blockchain_credential_subject_model.dart';

class BinanceAssociatedAddressModel extends BlockchainCredentialSubjectModel {
  BinanceAssociatedAddressModel({
    super.associatedAddress,
    required super.id,
    required super.type,
    super.issuedBy,
    super.offeredBy,
  }) : super(
         credentialSubjectType: CredentialSubjectType.binanceAssociatedWallet,
         credentialCategory: CredentialCategory.blockchainAccountsCards,
       );
}
