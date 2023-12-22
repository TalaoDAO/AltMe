// ignore_for_file: lines_longer_than_80_chars

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
}
