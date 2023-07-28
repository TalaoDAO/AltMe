enum OIDC4VCTye {
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
    oidc4VciDraft:
        'https://openid.net/specs/openid-connect-4-verifiable-credential-issuance-1_0-05.html#abstract',
    siopv2Draft: '',
    serviceDocumentation:
        'It is the profile of the EBSI V2 compliant test. DID for natural person is did:ebsi. The schema url is used as the VC type in the credential offer QR code. The prefix openid_initiate_issuance://',
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
    oidc4VciDraft:
        'https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0.html',
    siopv2Draft: '',
    serviceDocumentation: '',
  ),

  GAIAX(
    issuerVcType: 'ldp_vc',
    verifierVpType: 'ldp_vp',
    offerPrefix: 'openid-initiate-issuance://',
    presentationPrefix: 'openid-vc://',
    cryptographicBindingMethodsSupported: ['DID'],
    credentialSupported: ['EmployeeCredential'],
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
    oidc4VciDraft:
        'https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0.html',
    siopv2Draft: '',
    serviceDocumentation: 'Issuer pour projet Docaposte Gaia-X',
  ),

  DEFAULT(
    issuerVcType: 'ldp_vc',
    verifierVpType: 'ldp_vp',
    offerPrefix: 'openid-credential-offer://',
    presentationPrefix: 'openid-vc://',
    cryptographicBindingMethodsSupported: ['DID'],
    credentialSupported: [],
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
    subjectSyntaxTypesSupported: ['did:ebsi', 'did:key', 'did:ethr', 'did:tz'],
    schemaForType: false,
    oidc4VciDraft:
        'https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0.html',
    siopv2Draft: '',
    serviceDocumentation: 'Last release of the OIDC4VC documentation',
  ),

  ARF(
    issuerVcType: 'jwt_vc',
    verifierVpType: 'jwt_vp',
    offerPrefix: 'openid-credential-offer://',
    presentationPrefix: 'openid-vc://',
    cryptographicBindingMethodsSupported: ['DID'],
    credentialSupported: [],
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
    subjectSyntaxTypesSupported: ['did:ebsi', 'did:key', 'did:ethr', 'did:tz'],
    schemaForType: false,
    oidc4VciDraft: '',
    siopv2Draft: '',
    serviceDocumentation: '',
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
    subjectSyntaxTypesSupported: ['did:ion'],
    schemaForType: false,
    oidc4VciDraft: '',
    siopv2Draft: '',
    serviceDocumentation: '',
  );

  const OIDC4VCTye({
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
    required this.oidc4VciDraft,
    required this.siopv2Draft,
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
  final String oidc4VciDraft;
  final String siopv2Draft;
  final String serviceDocumentation;
}
