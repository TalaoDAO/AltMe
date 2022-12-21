import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'polygon_associated_address_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PolygonAssociatedAddressModel extends CredentialSubjectModel {
  PolygonAssociatedAddressModel({
    this.associatedAddress,
    this.accountName,
    required String id,
  }) : super(
          id: id,
          type: 'PolygonAssociatedAddress',
          credentialSubjectType: CredentialSubjectType.polygonAssociatedWallet,
          credentialCategory: CredentialCategory.blockchainAccountsCards,
          issuedBy: const Author('My Wallet', null),
        );

  factory PolygonAssociatedAddressModel.fromJson(Map<String, dynamic> json) =>
      _$PolygonAssociatedAddressModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? associatedAddress;

  @JsonKey(defaultValue: '')
  final String? accountName;

  @override
  Map<String, dynamic> toJson() => _$PolygonAssociatedAddressModelToJson(this);
}
