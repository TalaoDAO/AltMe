import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:json_annotation/json_annotation.dart';

part 'associated_wallet_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AssociatedWalletModel extends CredentialSubjectModel {
  AssociatedWalletModel({
    String? id,
    String? type,
    Author? issuedBy,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
          credentialSubjectType: CredentialSubjectType.associatedWallet,
          credentialCategory: CredentialCategory.othersCards,
        );

  factory AssociatedWalletModel.fromJson(Map<String, dynamic> json) =>
      _$AssociatedWalletModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AssociatedWalletModelToJson(this);
}
