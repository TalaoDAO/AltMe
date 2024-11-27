import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fantom_associated_address_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FantomAssociatedAddressModel extends CredentialSubjectModel {
  FantomAssociatedAddressModel({
    this.associatedAddress,
    required String super.id,
    required String super.type,
    required Author super.issuedBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.fantomAssociatedWallet,
          credentialCategory: CredentialCategory.blockchainAccountsCards,
        );

  factory FantomAssociatedAddressModel.fromJson(Map<String, dynamic> json) =>
      _$FantomAssociatedAddressModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? associatedAddress;

  @override
  Map<String, dynamic> toJson() => _$FantomAssociatedAddressModelToJson(this);
}
