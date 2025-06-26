import 'package:credential_manifest/src/models/format_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'format.g.dart';

@JsonSerializable(explicitToJson: true)
class Format {
  Format({
    this.jwtVp,
    this.jwtVc,
    this.jwtVpJson,
    this.jwtVcJson,
    this.ldpVp,
    this.ldpVc,
    this.vcSdJwt,
    this.jwtVcJsonLd,
    this.jwtVpJsonLd,
    this.dcSdJwt,
  });

  factory Format.fromJson(Map<String, dynamic> json) => _$FormatFromJson(json);

  @JsonKey(name: 'jwt_vp')
  FormatType? jwtVp;
  @JsonKey(name: 'jwt_vc')
  FormatType? jwtVc;
  @JsonKey(name: 'jwt_vp_json')
  FormatType? jwtVpJson;
  @JsonKey(name: 'jwt_vc_json')
  FormatType? jwtVcJson;
  @JsonKey(name: 'jwt_vp_json_ld')
  FormatType? jwtVpJsonLd;
  @JsonKey(name: 'jwt_vc_json_ld')
  FormatType? jwtVcJsonLd;
  @JsonKey(name: 'ldp_vp')
  FormatType? ldpVp;
  @JsonKey(name: 'ldp_vc')
  FormatType? ldpVc;
  @JsonKey(name: 'vc+sd-jwt')
  FormatType? vcSdJwt;
  @JsonKey(name: 'dc+sd-jwt')
  FormatType? dcSdJwt;

  Map<String, dynamic> toJson() => _$FormatToJson(this);
}
