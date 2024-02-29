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
  @JsonValue('vc+sd-jwt')
  vcSdJWT,
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
      case VCFormatType.vcSdJWT:
        return 'vc+sd-jwt (Experimental)';
    }
  }

  String get value {
    switch (this) {
      case VCFormatType.ldpVc:
        return 'ldp_vc';
      case VCFormatType.jwtVc:
        return 'jwt_vc';
      case VCFormatType.jwtVcJson:
        return 'jwt_vc_json';
      case VCFormatType.jwtVcJsonLd:
        return 'jwt_vc_json-ld';
      case VCFormatType.vcSdJWT:
        return 'vc+sd-jwt';
    }
  }

  String get urlValue {
    switch (this) {
      case VCFormatType.ldpVc:
        return 'ldp_vc';
      case VCFormatType.jwtVc:
        return 'jwt_vc';
      case VCFormatType.jwtVcJson:
        return 'jwt_vc_json';
      case VCFormatType.jwtVcJsonLd:
        return 'jwt_vc_json-ld';
      case VCFormatType.vcSdJWT:
        return 'vcsd-jwt';
    }
  }

  bool get supportCryptoCredential {
    switch (this) {
      case VCFormatType.ldpVc:
      case VCFormatType.jwtVcJson:
        return true;
      case VCFormatType.jwtVc:
      case VCFormatType.jwtVcJsonLd:
      case VCFormatType.vcSdJWT:
        return false;
    }
  }
}
