import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tezos_poo_address_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TezosPooAddressModel extends CredentialSubjectModel {
  TezosPooAddressModel({
    this.associatedAddress,
    super.id,
    super.type,
    super.issuedBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.tezosPooAddress,
          credentialCategory: CredentialCategory.blockchainAccountsCards,
        );

  factory TezosPooAddressModel.fromJson(Map<String, dynamic> json) =>
      _$TezosPooAddressModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? associatedAddress;

  @override
  Map<String, dynamic> toJson() => _$TezosPooAddressModelToJson(this);
}
