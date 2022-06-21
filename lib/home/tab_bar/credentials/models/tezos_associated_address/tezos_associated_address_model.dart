import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tezos_associated_address_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TezosAssociatedAddressModel extends CredentialSubjectModel {
  TezosAssociatedAddressModel({
    this.associatedAddress,
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

  factory TezosAssociatedAddressModel.fromJson(Map<String, dynamic> json) =>
      _$TezosAssociatedAddressModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? associatedAddress;

  @override
  Map<String, dynamic> toJson() => _$TezosAssociatedAddressModelToJson(this);
}
