import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fantom_poo_address_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FantomPooAddressModel extends CredentialSubjectModel {
  FantomPooAddressModel({
    this.associatedAddress,
    super.id,
    super.type,
    super.issuedBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.fantomPooAddress,
          credentialCategory: CredentialCategory.blockchainAccountsCards,
        );

  factory FantomPooAddressModel.fromJson(Map<String, dynamic> json) =>
      _$FantomPooAddressModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? associatedAddress;

  @override
  Map<String, dynamic> toJson() => _$FantomPooAddressModelToJson(this);
}
