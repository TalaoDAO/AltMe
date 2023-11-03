// ignore_for_file: lines_longer_than_80_chars

abstract class ConstantsJson {
  static const walletCredentialManifestJson = <String, dynamic>{
    'id': 'CredentialManifest',
    'issuer': {'id': '', 'name': 'Wallet issuer'},
    'output_descriptors': [
      {
        'id': '',
        'schema': 'CredentialManifest',
        'display': {
          'title': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': 'Device information',
          },
          'subtitle': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': 'Mobile device data',
          },
          'description': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback':
                'You can transfer this credential when you need to give assurance about your mobile device and wallet to a third party. It helps protect your apps from potentially risky and fraudulent interactions, allowing you to respond with appropriate actions to reduce attacks and abuse such as fraud, cheating, and unauthorized access. ',
          },
          'properties': [
            {
              'path': [r'$.credentialSubject.issuedBy.name'],
              'schema': {'type': 'string'},
              'fallback': 'My wallet',
              'label': 'Verified by',
            },
            {
              'path': [r'$.issuanceDate'],
              'schema': {'type': 'string', 'format': 'date'},
              'fallback': 'None',
              'label': 'Issue data',
            },
            {
              'path': [r'$.credentialSubject.systemName'],
              'schema': {'type': 'string'},
              'fallback': 'Unknown',
              'label': 'Operating System',
            },
            {
              'path': [r'$.credentialSubject.deviceName'],
              'schema': {'type': 'string'},
              'fallback': 'Unknown',
              'label': 'Device',
            },
            {
              'path': [r'$.credentialSubject.systemVersion'],
              'schema': {'type': 'string'},
              'fallback': 'Unknown',
              'label': 'System version',
            },
            {
              'path': [r'$.credentialSubject.walletBuild'],
              'schema': {'type': 'string'},
              'fallback': 'Unknown',
              'label': 'Wallet build',
            }
          ],
        },
      }
    ],
    'presentation_definition': <String, dynamic>{},
  };

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

  static const clientMetadata = <String, dynamic>{
    'authorization_endpoint': 'https://app.altme.io/app/download/authorize',
    'scopes_supported': ['openid'],
    'response_types_supported': ['vp_token', 'id_token'],
    'client_id_schemes_supported': ['redirect_uri', 'did'],
    'grant_types_supported': ['authorization_code', 'pre-authorized_code'],
    'subject_types_supported': ['public'],
    'id_token_signing_alg_values_supported': ['ES256', 'ES256K'],
    'request_object_signing_alg_values_supported': [
      'ES256',
      'ES256K',
    ],
    'request_parameter_supported': true,
    'request_uri_parameter_supported': true,
    'request_authentication_methods_supported': {
      'authorization_endpoint': ['request_object']
    },
    'vp_formats_supported': {
      'ldp_vp': {
        'proof_type': [
          'Ed25519Signature2018',
          'EcdsaSecp256k1Signature2019',
          'JsonWebSignature2020'
        ]
      },
      'ldp_vc': {
        'proof_type': [
          'Ed25519Signature2018',
          'EcdsaSecp256k1Signature2019',
          'JsonWebSignature2020'
        ]
      },
      'jwt_vp': {
        ' alg_values_supported': ['ES256', 'ES256K']
      },
      'jwt_vc': {
        'alg_values_supported': ['ES256', 'ES256K']
      }
    },
    'subject_syntax_types_supported': [
      'urn:ietf:params:oauth:jwk-thumbprint',
      'did:key',
      'did:jwk'
    ],
    'subject_syntax_types_discriminations': ['did🔑jwk_jcs-pub', 'did:ebsi:v1'],
    'subject_trust_frameworks_supported': ['ebsi'],
    'id_token_types_supported': ['subject_signed_id_token']
  };
}
