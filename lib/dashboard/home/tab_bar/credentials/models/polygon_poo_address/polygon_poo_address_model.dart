import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'polygon_poo_address_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PolygonPooAddressModel extends CredentialSubjectModel {
  PolygonPooAddressModel({
    this.associatedAddress,
    super.id,
    super.type,
    super.issuedBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.polygonPooAddress,
          credentialCategory: CredentialCategory.blockchainAccountsCards,
        );

  factory PolygonPooAddressModel.fromJson(Map<String, dynamic> json) =>
      _$PolygonPooAddressModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? associatedAddress;

  @override
  Map<String, dynamic> toJson() => _$PolygonPooAddressModelToJson(this);
}
