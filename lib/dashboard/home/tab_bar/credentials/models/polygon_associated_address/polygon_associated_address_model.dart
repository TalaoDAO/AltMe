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
    required String type,
    required Author issuedBy,
  }) : super(
          id: id,
          type: type,
          credentialSubjectType: CredentialSubjectType.polygonAssociatedWallet,
          credentialCategory: CredentialCategory.blockchainAccountsCards,
          issuedBy: issuedBy,
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
