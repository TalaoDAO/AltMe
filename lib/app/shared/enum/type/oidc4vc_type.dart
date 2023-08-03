import 'package:dio/dio.dart';
import 'package:oidc4vc/oidc4vc.dart';

enum OIDC4VCType {
  DEFAULT(
    issuerVcType: 'ldp_vc',
    verifierVpType: 'ldp_vp',
    offerPrefix: 'openid-credential-offer://',
    presentationPrefix: 'openid-vc://',
    cryptographicBindingMethodsSupported: ['DID'],
    credentialSupported: ['EmployeeCredential', 'VerifiableId'],
    grantTypesSupported: [
      'authorization_code',
      'urn:ietf:params:oauth:grant-type:pre-authorized_code'
    ],
    cryptographicSuitesSupported: [
      'ES256K',
      'ES256',
      'ES384',
      'ES512',
      'RS256'
    ],
    subjectSyntaxTypesSupported: ['did:key'],
    schemaForType: false,
    publicJWKNeeded: false,
    serviceDocumentation:
        '''WORK IN PROGRESS. WE use JSON-LD VC and VP and last release of the specs.\n'''
        '''oidc4vci_draft : https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0.html\n'''
        '''siopv2_draft : https://openid.net/specs/openid-connect-self-issued-v2-1_0.html\n'''
        '''oidc4vp_draft : https://openid.net/specs/openid-4-verifiable-presentations-1_0.html\n'''
        '''Issuer pour projet Docaposte Gaia-X''',
  ),

  EBSIV2(
    issuerVcType: 'jwt_vc',
    verifierVpType: 'jwt_vp',
    offerPrefix: 'openid://initiate_issuance',
    presentationPrefix: 'openid-vc://',
    cryptographicBindingMethodsSupported: ['DID'],
    cryptographicSuitesSupported: [
      'ES256K',
      'ES256',
      'ES384',
      'ES512',
      'RS256'
    ],
    subjectSyntaxTypesSupported: ['did:ebsi'],
    grantTypesSupported: [
      'authorization_code',
      'urn:ietf:params:oauth:grant-type:pre-authorized_code'
    ],
    credentialSupported: ['VerifiableDiploma', 'VerifiableId'],
    schemaForType: true,
    publicJWKNeeded: true,
    serviceDocumentation:
        '''EBSI V2 COMPLIANCE. It is the profile of the EBSI V2 compliant test. DID for natural person is did:ebsi.\n'''
        '''The schema url is used as the VC type in the credential offer QR code.\n'''
        '''The prefix openid_initiate_issuance://\n'''
        '''oidc4vci_draft : https://openid.net/specs/openid-connect-4-verifiable-credential-issuance-1_0-05.html#abstract''',
  ),

  GAIAX(
    issuerVcType: 'ldp_vc',
    verifierVpType: 'ldp_vp',
    offerPrefix: 'openid-initiate-issuance://',
    presentationPrefix: 'openid-vc://',
    cryptographicBindingMethodsSupported: ['DID'],
    credentialSupported: ['EmployeeCredential', 'VerifiableId'],
    grantTypesSupported: [
      'authorization_code',
      'urn:ietf:params:oauth:grant-type:pre-authorized_code'
    ],
    cryptographicSuitesSupported: [
      'ES256K',
      'ES256',
      'ES384',
      'ES512',
      'RS256'
    ],
    subjectSyntaxTypesSupported: ['did:key'],
    schemaForType: false,
    publicJWKNeeded: true,
    serviceDocumentation:
        '''WORK IN PROGRESS. WE use JSON-LD VC and VP and last release of the specs.\n'''
        '''oidc4vci_draft : https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0.html\n'''
        '''siopv2_draft : https://openid.net/specs/openid-connect-self-issued-v2-1_0.html\n'''
        '''oidc4vp_draft : https://openid.net/specs/openid-4-verifiable-presentations-1_0.html''',
  ),

  HEDERA(
    issuerVcType: 'jwt_vc',
    verifierVpType: 'jwt_vp',
    offerPrefix: 'openid-credential-offer-hedera://',
    presentationPrefix: 'openid-hedera://',
    cryptographicBindingMethodsSupported: ['DID'],
    credentialSupported: ['EmployeeCredential', 'ProofOfAsset'],
    grantTypesSupported: [
      'authorization_code',
      'urn:ietf:params:oauth:grant-type:pre-authorized_code'
    ],
    cryptographicSuitesSupported: [
      'ES256K',
      'ES256',
      'ES384',
      'ES512',
      'RS256'
    ],
    subjectSyntaxTypesSupported: ['did:key', 'did:pkh'],
    schemaForType: false,
    publicJWKNeeded: true,
    serviceDocumentation:
        '''WORK IN PROGRESS EON project. last release of the specs.\n'''
        '''oidc4vci_draft : https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0.html\n'''
        '''siopv2_draft : https://openid.net/specs/openid-connect-self-issued-v2-1_0.html\n'''
        '''oidc4vp_draft : https://openid.net/specs/openid-4-verifiable-presentations-1_0.html\n'''
        '''Issuer and verifier for marjetplace and WCM\n''',
  ),

  EBSIV3(
    issuerVcType: 'jwt_vc',
    verifierVpType: 'jwt_vp',
    offerPrefix: 'openid://initiate_issuance',
    presentationPrefix: 'openid-vc://',
    cryptographicBindingMethodsSupported: ['DID'],
    credentialSupported: ['VerifiableDiploma', 'VerifiableId'],
    grantTypesSupported: [
      'authorization_code',
      'urn:ietf:params:oauth:grant-type:pre-authorized_code'
    ],
    cryptographicSuitesSupported: [
      'ES256K',
      'ES256',
      'ES384',
      'ES512',
      'RS256'
    ],
    subjectSyntaxTypesSupported: ['did:key'],
    schemaForType: false,
    publicJWKNeeded: true,
    serviceDocumentation: 'New environment for V3 compliance test',
  ),

  JWTVC(
    issuerVcType: 'jwt_vc',
    offerPrefix: '',
    verifierVpType: 'jwt_vp',
    presentationPrefix: 'openid-vc://',
    cryptographicBindingMethodsSupported: ['DID'],
    credentialSupported: [],
    grantTypesSupported: [],
    cryptographicSuitesSupported: [
      'ES256K',
      'ES256',
      'ES384',
      'ES512',
      'RS256'
    ],
    subjectSyntaxTypesSupported: ['did:ion', 'did:web'],
    schemaForType: false,
    publicJWKNeeded: true,
    serviceDocumentation:
        'https://identity.foundation/jwt-vc-presentation-profile/',
  );

  const OIDC4VCType({
    required this.issuerVcType,
    required this.verifierVpType,
    required this.offerPrefix,
    required this.presentationPrefix,
    required this.cryptographicBindingMethodsSupported,
    required this.cryptographicSuitesSupported,
    required this.subjectSyntaxTypesSupported,
    required this.grantTypesSupported,
    required this.credentialSupported,
    required this.schemaForType,
    required this.publicJWKNeeded,
    required this.serviceDocumentation,
  });

  final String issuerVcType;
  final String verifierVpType;
  final String offerPrefix;
  final String presentationPrefix;
  final List<String> cryptographicBindingMethodsSupported;
  final List<String> cryptographicSuitesSupported;
  final List<String> subjectSyntaxTypesSupported;
  final List<String> grantTypesSupported;
  final List<String> credentialSupported;
  final bool schemaForType;
  final bool publicJWKNeeded;
  final String serviceDocumentation;
}

extension OIDC4VCTypeX on OIDC4VCType {
  OIDC4VC get getOIDC4VC {
    return OIDC4VC(
      client: Dio(),
      oidc4vcModel: OIDC4VCModel(
        issuerVcType: issuerVcType,
        verifierVpType: verifierVpType,
        offerPrefix: offerPrefix,
        presentationPrefix: presentationPrefix,
        cryptographicBindingMethodsSupported:
            cryptographicBindingMethodsSupported,
        cryptographicSuitesSupported: cryptographicSuitesSupported,
        subjectSyntaxTypesSupported: subjectSyntaxTypesSupported,
        grantTypesSupported: grantTypesSupported,
        credentialSupported: credentialSupported,
        schemaForType: schemaForType,
        publicJWKNeeded: publicJWKNeeded,
        serviceDocumentation: serviceDocumentation,
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

  bool get isEnabled {
    switch (this) {
      case OIDC4VCType.DEFAULT:
      case OIDC4VCType.EBSIV2:
      case OIDC4VCType.GAIAX:
      case OIDC4VCType.HEDERA:
        return true;
      case OIDC4VCType.EBSIV3:
      case OIDC4VCType.JWTVC:
        return false;
    }
  }
}
