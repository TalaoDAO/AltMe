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
            'fallback': 'Device information'
          },
          'subtitle': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': 'Mobile device data'
          },
          'description': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback':
                'You can transfer this credential when you need to give assurance about your mobile device and wallet to a third party. It helps protect your apps from potentially risky and fraudulent interactions, allowing you to respond with appropriate actions to reduce attacks and abuse such as fraud, cheating, and unauthorized access. '
          },
          'properties': [
            {
              'path': [r'$.credentialSubject.issuedBy.name'],
              'schema': {'type': 'string'},
              'fallback': 'My wallet',
              'label': 'Verified by'
            },
            {
              'path': [r'$.issuanceDate'],
              'schema': {'type': 'string', 'format': 'date'},
              'fallback': 'None',
              'label': 'Issue data'
            },
            {
              'path': [r'$.credentialSubject.systemName'],
              'schema': {'type': 'string'},
              'fallback': 'Unknown',
              'label': 'Operating System'
            },
            {
              'path': [r'$.credentialSubject.deviceName'],
              'schema': {'type': 'string'},
              'fallback': 'Unknown',
              'label': 'Device'
            },
            {
              'path': [r'$.credentialSubject.systemVersion'],
              'schema': {'type': 'string'},
              'fallback': 'Unknown',
              'label': 'System version'
            },
            {
              'path': [r'$.credentialSubject.walletBuild'],
              'schema': {'type': 'string'},
              'fallback': 'Unknown',
              'label': 'Wallet build'
            }
          ]
        }
      }
    ],
    'presentation_definition': <String, dynamic>{}
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
            'fallback': 'Tezos address'
          },
          'subtitle': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': ''
          },
          'description': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': 'This is the proof that you own this crypto address'
          },
          'properties': [
            {
              'path': [r'$.expirationDate'],
              'schema': {'type': 'string', 'format': 'date'},
              'fallback': 'None',
              'label': 'Expires'
            },
            {
              'path': [r'$.credentialSubject.associatedAddress'],
              'schema': {'type': 'string'},
              'fallback': 'Unknown',
              'label': 'Address'
            },
            {
              'path': [r'$.credentialSubject.issuedBy.name'],
              'schema': {'type': 'string'},
              'fallback': 'My Wallet',
              'label': 'Verified by'
            }
          ]
        }
      }
    ],
    'presentation_definition': <String, dynamic>{}
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
            'fallback': 'Ethereum address'
          },
          'subtitle': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': ''
          },
          'description': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': 'This is the proof that you own this crypto address'
          },
          'properties': [
            {
              'path': [r'$.expirationDate'],
              'schema': {'type': 'string', 'format': 'date'},
              'fallback': 'None',
              'label': 'Expires'
            },
            {
              'path': [r'$.credentialSubject.associatedAddress'],
              'schema': {'type': 'string'},
              'fallback': 'Unknown',
              'label': 'Address'
            },
            {
              'path': [r'$.credentialSubject.issuedBy.name'],
              'schema': {'type': 'string'},
              'fallback': 'My Wallet',
              'label': 'Verified by'
            }
          ]
        }
      }
    ],
    'presentation_definition': <String, dynamic>{}
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
            'fallback': 'Fantom address'
          },
          'subtitle': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': ''
          },
          'description': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': 'This is the proof that you own this crypto address'
          },
          'properties': [
            {
              'path': [r'$.expirationDate'],
              'schema': {'type': 'string', 'format': 'date'},
              'fallback': 'None',
              'label': 'Expires'
            },
            {
              'path': [r'$.credentialSubject.associatedAddress'],
              'schema': {'type': 'string'},
              'fallback': 'Unknown',
              'label': 'Address'
            },
            {
              'path': [r'$.credentialSubject.issuedBy.name'],
              'schema': {'type': 'string'},
              'fallback': 'My Wallet',
              'label': 'Verified by'
            }
          ]
        }
      }
    ],
    'presentation_definition': <String, dynamic>{}
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
            'fallback': 'Polygon address'
          },
          'subtitle': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': ''
          },
          'description': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': 'This is the proof that you own this crypto address'
          },
          'properties': [
            {
              'path': [r'$.expirationDate'],
              'schema': {'type': 'string', 'format': 'date'},
              'fallback': 'None',
              'label': 'Expires'
            },
            {
              'path': [r'$.credentialSubject.associatedAddress'],
              'schema': {'type': 'string'},
              'fallback': 'Unknown',
              'label': 'Address'
            },
            {
              'path': [r'$.credentialSubject.issuedBy.name'],
              'schema': {'type': 'string'},
              'fallback': 'My Wallet',
              'label': 'Verified by'
            }
          ]
        }
      }
    ],
    'presentation_definition': <String, dynamic>{}
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
            'fallback': 'Binance address'
          },
          'subtitle': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': ''
          },
          'description': {
            'path': <dynamic>[],
            'schema': {'type': 'string'},
            'fallback': 'This is the proof that you own this crypto address'
          },
          'properties': [
            {
              'path': [r'$.expirationDate'],
              'schema': {'type': 'string', 'format': 'date'},
              'fallback': 'None',
              'label': 'Expires'
            },
            {
              'path': [r'$.credentialSubject.associatedAddress'],
              'schema': {'type': 'string'},
              'fallback': 'Unknown',
              'label': 'Address'
            },
            {
              'path': [r'$.credentialSubject.issuedBy.name'],
              'schema': {'type': 'string'},
              'fallback': 'My Wallet',
              'label': 'Verified by'
            }
          ]
        }
      }
    ],
    'presentation_definition': <String, dynamic>{}
  };
}
