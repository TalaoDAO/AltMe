import 'package:dio/dio.dart';
import 'package:oidc4vc/oidc4vc.dart';

enum OIDC4VCType {
  DEFAULT(
    issuerVcType: 'ldp_vc',
    verifierVpType: 'ldp_vp',
    offerPrefix: 'openid-credential-offer://',
    presentationPrefix: 'openid-vc://',
    publicJWKNeeded: false,
  ),

  EBSIV2(
    issuerVcType: 'jwt_vc', // jwt_vc_json, jwt_vc_json-ld, ldp_vc
    verifierVpType: 'jwt_vp',
    offerPrefix: 'openid://initiate_issuance',
    presentationPrefix: 'openid://',
    publicJWKNeeded: true,
  ),

  GAIAX(
    issuerVcType: 'ldp_vc',
    verifierVpType: 'ldp_vp',
    offerPrefix: 'openid-initiate-issuance://',
    presentationPrefix: 'openid://',
    publicJWKNeeded: false,
  ),

  HEDERA(
    issuerVcType: 'jwt_vc',
    verifierVpType: 'jwt_vp',
    offerPrefix: 'openid-credential-offer-hedera://',
    presentationPrefix: 'openid-hedera://',
    publicJWKNeeded: false,
  ),

  EBSIV3(
    issuerVcType: 'jwt_vc',
    verifierVpType: 'jwt_vp',
    offerPrefix: 'openid://initiate_issuance',
    presentationPrefix: 'openid-vc://',
    publicJWKNeeded: false,
  ),

  JWTVC(
    issuerVcType: 'jwt_vc',
    offerPrefix: '',
    verifierVpType: 'jwt_vp',
    presentationPrefix: 'openid-vc://',
    publicJWKNeeded: false,
  );

  const OIDC4VCType({
    required this.issuerVcType,
    required this.verifierVpType,
    required this.offerPrefix,
    required this.presentationPrefix,
    required this.publicJWKNeeded,
  });

  final String issuerVcType;
  final String verifierVpType;
  final String offerPrefix;
  final String presentationPrefix;
  final bool publicJWKNeeded;
}

extension OIDC4VCTypeX on OIDC4VCType {
  OIDC4VC get getOIDC4VC {
    return OIDC4VC(
      client: Dio(),
      oidc4vcModel: OIDC4VCModel(
        offerPrefix: offerPrefix,
        presentationPrefix: presentationPrefix,
        publicJWKNeeded: publicJWKNeeded,
      ),
    );
  }

  String get rename {
    switch (this) {
      case OIDC4VCType.DEFAULT:
        return 'DEFAULT';
      case OIDC4VCType.GAIAX:
        return 'GAIA-X';
      case OIDC4VCType.EBSIV2:
        return 'EBSI-V2';
      case OIDC4VCType.EBSIV3:
        return 'EBSI-V3';
      case OIDC4VCType.HEDERA:
        return 'HEDERA';
      case OIDC4VCType.JWTVC:
        return 'JWT-VC';
    }
  }

  int get indexValue {
    switch (this) {
      case OIDC4VCType.DEFAULT:
      case OIDC4VCType.GAIAX:
      case OIDC4VCType.HEDERA:
      case OIDC4VCType.JWTVC:
        return 1;
      case OIDC4VCType.EBSIV2:
        return 2;
      case OIDC4VCType.EBSIV3:
        return 3;
    }
  }

  bool get isEnabled {
    switch (this) {
      case OIDC4VCType.DEFAULT:
      case OIDC4VCType.EBSIV2:
      case OIDC4VCType.GAIAX:
      case OIDC4VCType.HEDERA:
      case OIDC4VCType.EBSIV3:
        return true;
      case OIDC4VCType.JWTVC:
        return false;
    }
  }

  bool get schemaForType => this == OIDC4VCType.EBSIV2;
}
