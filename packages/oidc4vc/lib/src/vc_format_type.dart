import 'package:json_annotation/json_annotation.dart';

enum VCFormatType {
  @JsonValue('ldp_vc')
  ldpVc,
  @JsonValue('jwt_vc')
  jwtVc,
  @JsonValue('jwt_vc_json')
  jwtVcJson,
  @JsonValue('jwt_vc_json-ld')
  jwtVcJsonLd,
}

extension VCFormatTypeX on VCFormatType {
  String get formattedString {
    switch (this) {
      case VCFormatType.ldpVc:
        return 'ldp_vc';
      case VCFormatType.jwtVc:
        return 'jwt_vc';
      case VCFormatType.jwtVcJson:
        return 'jwt_vc_json';
      case VCFormatType.jwtVcJsonLd:
        return 'jwt_vc_json-ld';
    }
  }
}