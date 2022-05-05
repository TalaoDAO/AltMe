import 'package:json_annotation/json_annotation.dart';

part 'organization_info.g.dart';

@JsonSerializable()
class OrganizationInfo {
  OrganizationInfo({
    required this.id,
    required this.legalName,
    required this.currentAddress,
    required this.website,
    required this.issuerDomain,
  });

  factory OrganizationInfo.fromJson(Map<String, dynamic> json) =>
      _$OrganizationInfoFromJson(json);

  factory OrganizationInfo.emptyOrganizationInfo() => OrganizationInfo(
        id: '',
        legalName: '',
        website: '',
        issuerDomain: [],
        currentAddress: '',
      );

  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String legalName;
  @JsonKey(defaultValue: '')
  final String currentAddress;
  @JsonKey(defaultValue: '')
  final String website;
  @JsonKey(defaultValue: <String>[])
  final List<String> issuerDomain;

  Map<String, dynamic> toJson() => _$OrganizationInfoToJson(this);
}
