import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet_credential_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WalletCredentialModel extends CredentialSubjectModel {
  WalletCredentialModel({
    this.publicKey,
    this.walletInstanceKey,
    super.id,
    super.type,
    required Author super.issuedBy,
    super.offeredBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.walletCredential,
          credentialCategory: CredentialCategory.othersCards,
        );

  factory WalletCredentialModel.fromJson(Map<String, dynamic> json) =>
      _$WalletCredentialModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? publicKey;

  @JsonKey(defaultValue: '')
  final String? walletInstanceKey;

  @override
  Map<String, dynamic> toJson() => _$WalletCredentialModelToJson(this);
}
