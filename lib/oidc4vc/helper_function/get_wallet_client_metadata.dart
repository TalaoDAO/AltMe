import 'package:altme/app/app.dart';

Map<String, dynamic> walletClientMetadata(
    String walletCleintTokenEndpointAuthMethod,
  ) {
    return {
      'authorization_endpoint': Parameters.authorizationEndPoint,
      'scopes_supported': ['openid'],
      'response_types_supported': ['vp_token', 'id_token'],
      'client_id_schemes_supported': ['redirect_uri', 'did'],
      'grant_types_supported': ['authorization_code', 'pre-authorized_code'],
      'subject_types_supported': ['public'],
      'id_token_signing_alg_values_supported': ['ES256', 'ES256K'],
      'request_object_signing_alg_values_supported': ['ES256', 'ES256K'],
      'request_parameter_supported': true,
      'request_uri_parameter_supported': true,
      'request_authentication_methods_supported': {
        'authorization_endpoint': ['request_object'],
      },
      'vp_formats_supported': {
        'jwt_vp': {
          'alg_values_supported': ['ES256', 'ES256K'],
        },
        'jwt_vc': {
          'alg_values_supported': ['ES256', 'ES256K'],
        },
      },
      'subject_syntax_types_supported': [
        'urn:ietf:params:oauth:jwk-thumbprint',
        'did:key',
        'did:pkh',
        'did:key',
      ],
      'subject_syntax_types_discriminations': [
        'did:key:jwk_jcs-pub',
        'did:ebsi:v1',
      ],
      'subject_trust_frameworks_supported': ['ebsi'],
      'id_token_types_supported': ['subject_signed_id_token'],
      'token_endpoint_auth_method': walletCleintTokenEndpointAuthMethod,
    };
  }
