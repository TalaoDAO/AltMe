// ignore_for_file: lines_longer_than_80_chars

import 'package:altme/app/app.dart';

abstract class ConstantsJson {
  static const tezosAssociatedAddressCredentialManifestJson = <String, dynamic>{
    'id': 'TezosAssociatedAddress',
    'issuer': {'id': '', 'name': 'Wallet issuer'},
    'output_descriptors': [
      {
        'id': '',
        'schema': 'TezosAssociatedAddress',
        'display': {
          'title': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': 'Tezos address',
          },
          'subtitle': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': '',
          },
          'description': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': 'This is the proof that you own this crypto address',
          },
          'properties': [
            {
              'path': [r'$.expirationDate'],
              'schema': {'type': 'string', 'format': 'date'},
              'fallback': 'None',
              'label': 'Expires',
            },
            {
              'path': [r'$.credentialSubject.associatedAddress'],
              'schema': {'type': 'string'},
              'fallback': 'Unknown',
              'label': 'Address',
            },
            {
              'path': [r'$.credentialSubject.issuedBy.name'],
              'schema': {'type': 'string'},
              'fallback': 'My Wallet',
              'label': 'Verified by',
            }
          ],
        },
      }
    ],
    'presentation_definition': <String, dynamic>{},
  };

  static const ethereumAssociatedAddressCredentialManifestJson =
      <String, dynamic>{
    'id': 'EthereumAssociatedAddress',
    'issuer': {'id': '', 'name': 'Wallet issuer'},
    'output_descriptors': [
      {
        'id': '',
        'schema': 'EthereumAssociatedAddress',
        'display': {
          'title': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': 'Ethereum address',
          },
          'subtitle': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': '',
          },
          'description': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': 'This is the proof that you own this crypto address',
          },
          'properties': [
            {
              'path': [r'$.expirationDate'],
              'schema': {'type': 'string', 'format': 'date'},
              'fallback': 'None',
              'label': 'Expires',
            },
            {
              'path': [r'$.credentialSubject.associatedAddress'],
              'schema': {'type': 'string'},
              'fallback': 'Unknown',
              'label': 'Address',
            },
            {
              'path': [r'$.credentialSubject.issuedBy.name'],
              'schema': {'type': 'string'},
              'fallback': 'My Wallet',
              'label': 'Verified by',
            }
          ],
        },
      }
    ],
    'presentation_definition': <String, dynamic>{},
  };

  static const etherlinkAssociatedAddressCredentialManifestJson =
      <String, dynamic>{
    'id': 'EtherlinkAssociatedAddress',
    'issuer': {'id': '', 'name': 'Wallet issuer'},
    'output_descriptors': [
      {
        'id': '',
        'schema': 'EtherlinkAssociatedAddress',
        'display': {
          'title': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': 'Etherlink address',
          },
          'subtitle': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': '',
          },
          'description': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': 'This is the proof that you own this crypto address',
          },
          'properties': [
            {
              'path': [r'$.expirationDate'],
              'schema': {'type': 'string', 'format': 'date'},
              'fallback': 'None',
              'label': 'Expires',
            },
            {
              'path': [r'$.credentialSubject.associatedAddress'],
              'schema': {'type': 'string'},
              'fallback': 'Unknown',
              'label': 'Address',
            },
            {
              'path': [r'$.credentialSubject.issuedBy.name'],
              'schema': {'type': 'string'},
              'fallback': 'My Wallet',
              'label': 'Verified by',
            }
          ],
        },
      }
    ],
    'presentation_definition': <String, dynamic>{},
  };

  static const fantomAssociatedAddressCredentialManifestJson =
      <String, dynamic>{
    'id': 'FantomAssociatedAddress',
    'issuer': {'id': '', 'name': 'Wallet issuer'},
    'output_descriptors': [
      {
        'id': '',
        'schema': 'FantomAssociatedAddress',
        'display': {
          'title': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': 'Fantom address',
          },
          'subtitle': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': '',
          },
          'description': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': 'This is the proof that you own this crypto address',
          },
          'properties': [
            {
              'path': [r'$.expirationDate'],
              'schema': {'type': 'string', 'format': 'date'},
              'fallback': 'None',
              'label': 'Expires',
            },
            {
              'path': [r'$.credentialSubject.associatedAddress'],
              'schema': {'type': 'string'},
              'fallback': 'Unknown',
              'label': 'Address',
            },
            {
              'path': [r'$.credentialSubject.issuedBy.name'],
              'schema': {'type': 'string'},
              'fallback': 'My Wallet',
              'label': 'Verified by',
            }
          ],
        },
      }
    ],
    'presentation_definition': <String, dynamic>{},
  };

  static const polygonAssociatedAddressCredentialManifestJson =
      <String, dynamic>{
    'id': 'PolygonAssociatedAddress',
    'issuer': {'id': '', 'name': 'Wallet issuer'},
    'output_descriptors': [
      {
        'id': '',
        'schema': 'PolygonAssociatedAddress',
        'display': {
          'title': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': 'Polygon address',
          },
          'subtitle': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': '',
          },
          'description': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': 'This is the proof that you own this crypto address',
          },
          'properties': [
            {
              'path': [r'$.expirationDate'],
              'schema': {'type': 'string', 'format': 'date'},
              'fallback': 'None',
              'label': 'Expires',
            },
            {
              'path': [r'$.credentialSubject.associatedAddress'],
              'schema': {'type': 'string'},
              'fallback': 'Unknown',
              'label': 'Address',
            },
            {
              'path': [r'$.credentialSubject.issuedBy.name'],
              'schema': {'type': 'string'},
              'fallback': 'My Wallet',
              'label': 'Verified by',
            }
          ],
        },
      }
    ],
    'presentation_definition': <String, dynamic>{},
  };

  static const binanceAssociatedAddressCredentialManifestJson =
      <String, dynamic>{
    'id': 'BinanceAssociatedAddress',
    'issuer': {'id': '', 'name': 'Wallet issuer'},
    'output_descriptors': [
      {
        'id': '',
        'schema': 'BinanceAssociatedAddress',
        'display': {
          'title': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': 'BNB Chain address',
          },
          'subtitle': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': '',
          },
          'description': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': 'This is the proof that you own this crypto address',
          },
          'properties': [
            {
              'path': [r'$.expirationDate'],
              'schema': {'type': 'string', 'format': 'date'},
              'fallback': 'None',
              'label': 'Expires',
            },
            {
              'path': [r'$.credentialSubject.associatedAddress'],
              'schema': {'type': 'string'},
              'fallback': 'Unknown',
              'label': 'Address',
            },
            {
              'path': [r'$.credentialSubject.issuedBy.name'],
              'schema': {'type': 'string'},
              'fallback': 'My Wallet',
              'label': 'Verified by',
            }
          ],
        },
      }
    ],
    'presentation_definition': <String, dynamic>{},
  };

  static const walletMetadataForIssuers = <String, dynamic>{
    'vp_formats_supported': {
      'jwt_vp': {
        'alg': ['ES256', 'ES256K', 'EdDSA'],
      },
      'jwt_vc': {
        'alg': ['ES256', 'ES256K', 'EdDSA'],
      },
      'jwt_vp_json': {
        'alg': ['ES256', 'ES256K', 'EdDSA'],
      },
      'jwt_vc_json': {
        'alg': ['ES256', 'ES256K', 'EdDSA'],
      },
      'vc+sd-jwt': {
        'alg': ['ES256', 'ES256K', 'EdDSA'],
      },
      'ldp_vp': {
        'proof_type': [
          'JsonWebSignature2020',
          'Ed25519Signature2018',
          'EcdsaSecp256k1Signature2019',
          'RsaSignature2018'
        ],
      },
      'ldp_vc': {
        'proof_type': [
          'JsonWebSignature2020',
          'Ed25519Signature2018',
          'EcdsaSecp256k1Signature2019',
          'RsaSignature2018',
        ],
      },
    },
    'grant_types': ['authorization code', 'pre-authorized_code'],
    'redirect_uris': [Parameters.authorizationEndPoint],
    'subject_syntax_types_supported': ['did:key', 'did:jwk'],
    'subject_syntax_types_discriminations': [
      'did:key:jwk_jcs-pub',
      'did:ebsi:v1',
    ],
    'token_endpoint_auth_method_supported': [
      'none',
      'client_id',
      'client_secret_post',
      'client_secret_basic',
      'client_secret_jwt',
    ],
    'credential_offer_endpoint': ['openid-credential-offer://', 'haip://'],
    'client_name': '${Parameters.appName} wallet',
    'contacts': ['contact@talao.io'],
  };

  static const walletMetadataForVerifiers = <String, dynamic>{
    'wallet_name': Parameters.walletName,
    'key_type': 'software',
    'user_authentication': 'system_biometry',
    'authorization_endpoint': Parameters.authorizationEndPoint,
    'grant_types_supported': ['authorization_code', 'pre-authorized_code'],
    'response_types_supported': ['vp_token', 'id_token'],
    'vp_formats_supported': {
      'jwt_vc_json': {
        'alg_values_supported': ['ES256', 'ES256K', 'EdDSA'],
      },
      'jwt_vp_json': {
        'alg_values_supported': ['ES256', 'ES256K', 'EdDSA'],
      },
      'vc+sd-jwt': {
        'alg_values_supported': ['ES256', 'ES256K', 'EdDSA'],
      },
      'ldp_vp': {
        'proof_type': [
          'JsonWebSignature2020',
          'Ed25519Signature2018',
          'EcdsaSecp256k1Signature2019',
          'RsaSignature2018',
        ],
      },
      'ldp_vc': {
        'proof_type': [
          'JsonWebSignature2020',
          'Ed25519Signature2018',
          'EcdsaSecp256k1Signature2019',
          'RsaSignature2018',
        ],
      },
    },
    'client_id_schemes_supported': [
      'did',
      'redirect_uri',
      'x509_san_dns',
      'verifier_attestation',
    ],
    'request_object_signing_alg_values_supported': ['ES256', 'ES256K'],
    'presentation_definition_uri_supported': true,
    'contacts': ['contact@talao.io'],
  };
}
