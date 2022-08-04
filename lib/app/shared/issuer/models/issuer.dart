import 'package:altme/app/shared/issuer/models/organization_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'issuer.g.dart';

@JsonSerializable()
class Issuer {
  Issuer({
    required this.preferredName,
    required this.did,
    required this.organizationInfo,
  });

  factory Issuer.fromJson(Map<String, dynamic> json) => _$IssuerFromJson(json);

  factory Issuer.emptyIssuer(String domain) => Issuer(
        preferredName: '',
        did: [],
        organizationInfo: OrganizationInfo.emptyOrganizationInfo(domain),
      );

  @JsonKey(defaultValue: '')
  final String preferredName;
  @JsonKey(defaultValue: <String>[])
  final List<String> did;
  final OrganizationInfo organizationInfo;

  Map<String, dynamic> toJson() => _$IssuerToJson(this);
}
