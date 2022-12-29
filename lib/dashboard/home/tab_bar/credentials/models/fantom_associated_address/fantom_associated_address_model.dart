import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fantom_associated_address_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FantomAssociatedAddressModel extends CredentialSubjectModel {
  FantomAssociatedAddressModel({
    this.associatedAddress,
    this.accountName,
    required String id,
    required String type,
    required Author issuedBy,
  }) : super(
          id: id,
          type: type,
          credentialSubjectType: CredentialSubjectType.fantomAssociatedWallet,
          credentialCategory: CredentialCategory.blockchainAccountsCards,
          issuedBy: issuedBy,
        );

  factory FantomAssociatedAddressModel.fromJson(Map<String, dynamic> json) =>
      _$FantomAssociatedAddressModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? associatedAddress;

  @JsonKey(defaultValue: '')
  final String? accountName;

  @override
  Map<String, dynamic> toJson() => _$FantomAssociatedAddressModelToJson(this);
}
