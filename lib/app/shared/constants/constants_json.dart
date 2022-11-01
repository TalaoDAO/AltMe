abstract class ConstantsJson {
  static const tezosAssociatedAddressCredentialManifestJson = <String, dynamic>{
    'id': 'TezosAssociatedAddress',
    'issuer': {'id': '', 'name': 'Altme issuer sandbox'},
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
}
