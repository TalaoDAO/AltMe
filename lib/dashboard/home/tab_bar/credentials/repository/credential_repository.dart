import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:secure_storage/secure_storage.dart';

class CredentialsRepository {
  CredentialsRepository(SecureStorageProvider secureStorageProvider)
      : _secureStorageProvider = secureStorageProvider;

  final SecureStorageProvider _secureStorageProvider;

  Future<List<CredentialModel>> findAll(/* dynamic filters */) async {
    try {
      getLogger('JsonDecode').wtf(CredentialModel.fromJson(asdf));
      final data = await _secureStorageProvider.getAllValues();
      data.removeWhere(
        (key, value) => !key.startsWith(
          '${SecureStorageKeys.credentialKey}/',
        ),
      );
      final _credentialList = <CredentialModel>[];
      data.forEach((key, value) {
        _credentialList.add(
          CredentialModel.fromJson(json.decode(value) as Map<String, dynamic>),
        );
      });
      return _credentialList;
    } catch (e) {
      getLogger('Error').e(e.toString());
      throw ResponseMessage(
        ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
      );
    }
  }

  Future<CredentialModel?> findById(String id) async {
    final String? data = await _secureStorageProvider
        .get('${SecureStorageKeys.credentialKey}/$id');
    if (data == null) {
      return null;
    }
    if (data.isEmpty) return null;

    return CredentialModel.fromJson(json.decode(data) as Map<String, dynamic>);
  }

  Future<int> deleteAll() async {
    final data = await _secureStorageProvider.getAllValues();
    data.removeWhere(
      (key, value) => !key.startsWith('${SecureStorageKeys.credentialKey}/'),
    );
    var numberOfDeletedCredentials = 0;
    data.forEach((key, value) {
      _secureStorageProvider.delete(key);
      numberOfDeletedCredentials++;
    });
    return numberOfDeletedCredentials;
  }

  Future<bool> deleteById(String id) async {
    await _secureStorageProvider
        .delete('${SecureStorageKeys.credentialKey}/$id');
    return true;
  }

  Future<int> insert(CredentialModel credential) async {
    await _secureStorageProvider.set(
      '${SecureStorageKeys.credentialKey}/${credential.id}',
      json.encode(credential.toJson()),
    );
    return 1;
  }

  Future<int> update(CredentialModel credential) async {
    await _secureStorageProvider.set(
      '${SecureStorageKeys.credentialKey}/${credential.id}',
      json.encode(credential.toJson()),
    );
    return 1;
  }
}

Map<String, dynamic> asdf = <String, dynamic>{
  'id': 'urn:uuid:11a0991c-5b64-490c-92ea-e742d7b0e352',
  'receivedId': null,
  'image': 'image',
  'data': {
    '@context': [
      'https://www.w3.org/2018/credentials/v1',
      {
        'accountName': 'https://schema.org/identifier',
        'associatedAddress': 'https://schema.org/account'
      }
    ],
    'id': 'urn:uuid:03813126-470a-47da-bf8a-355f7d84e429',
    'type': ['VerifiableCredential', 'TezosAssociatedAddress'],
    'credentialSubject': {
      'id': 'did:key:z6MkuayGPWTHjUKCe22xj8qaFZx32Ag6c9zRU3n1eZZfRrun',
      'accountName': 'My Account 1',
      'type': 'TezosAssociatedAddress',
      'associatedAddress': 'tz1PbAzqakr1cexEbHgud2HWvncqK6iYJqme'
    },
    'issuer': 'did:key:z6MkeXqo1XCvqXTbMJm4XnR4tdSKEgLh31tCUiuVgjoW1iS2',
    'issuanceDate': '2022-08-02T18:23:15Z',
    'proof': {
      'type': 'Ed25519Signature2018',
      'proofPurpose': 'assertionMethod',
      'verificationMethod':
          'did:key:z6MkeXqo1XCvqXTbMJm4XnR4tdSKEgLh31tCUiuVgjoW1iS2#z6MkeXqo1XCvqXTbMJm4XnR4tdSKEgLh31tCUiuVgjoW1iS2',
      'created': '2022-08-02T12:38:15.994Z',
      'jws':
          'eyJhbGciOiJFZERTQSIsImNyaXQiOlsiYjY0Il0sImI2NCI6ZmFsc2V9..O2GwzrsQBmvaazjjOpjT1-O0YLDUHYE8gekvwlYzVMjL_A_5WBAWUI70QOctceOiefG3MRwmZob6qsZg47FpCg'
    }
  },
  'shareLink': '',
  'credentialPreview': {
    'id': 'urn:uuid:03813126-470a-47da-bf8a-355f7d84e429',
    'type': ['VerifiableCredential', 'TezosAssociatedAddress'],
    'issuer': 'did:key:z6MkeXqo1XCvqXTbMJm4XnR4tdSKEgLh31tCUiuVgjoW1iS2',
    'issuanceDate': '2022-08-02T18:23:15Z',
    'proof': [
      {
        'type': 'Ed25519Signature2018',
        'proofPurpose': 'assertionMethod',
        'verificationMethod':
            'did:key:z6MkeXqo1XCvqXTbMJm4XnR4tdSKEgLh31tCUiuVgjoW1iS2#z6MkeXqo1XCvqXTbMJm4XnR4tdSKEgLh31tCUiuVgjoW1iS2',
        'created': '2022-08-02T12:38:15.994Z',
        'jws':
            'eyJhbGciOiJFZERTQSIsImNyaXQiOlsiYjY0Il0sImI2NCI6ZmFsc2V9..O2GwzrsQBmvaazjjOpjT1-O0YLDUHYE8gekvwlYzVMjL_A_5WBAWUI70QOctceOiefG3MRwmZob6qsZg47FpCg'
      }
    ],
    'credentialSubject': {
      'id': 'did:key:z6MkuayGPWTHjUKCe22xj8qaFZx32Ag6c9zRU3n1eZZfRrun',
      'type': 'TezosAssociatedAddress',
      'associatedAddress': 'tz1PbAzqakr1cexEbHgud2HWvncqK6iYJqme',
      'accountName': 'My Account 1'
    },
    'credentialStatus': {
      'id': '',
      'type': '',
      'revocationListIndex': '',
      'revocationListCredential': ''
    }
  },
  'display': {
    'backgroundColor': '',
    'icon': '',
    'nameFallback': '',
    'descriptionFallback': ''
  },
  'expirationDate': null,
  'credential_manifest': null,
  'challenge': null,
  'domain': null,
  'activities': [
    {
      'issuer': {
        'preferredName': 'Talao',
        'did': [
          'did:web:talao.co',
          'did:ethr:0xee09654eedaa79429f8d216fa51a129db0f72250',
          'did:tz:tz2NQkPq3FFA3zGAyG8kLcWatGbeXpHMu7yk',
          'did:ethr:0xd6008c16068c40c05a5574525db31053ae8b3ba7',
          'did:tz:tz1NyjrTUNxDpPaqNZ84ipGELAcTWYg6s5Du',
          'did:tz:tz2UFjbN9ZruP5pusKoAKiPD3ZLV49CBG9Ef'
        ],
        'organizationInfo': {
          'id': '837674480',
          'legalName': 'Talao SAS',
          'currentAddress': 'Talao, 16 rue de Wattignies, 75012 Paris, France',
          'website': 'https://talao.co',
          'issuerDomain': [
            'talao.co',
            'issuer.talao.co',
            'talao.io',
            'tezotopia.talao.co',
            'playground.talao.co',
            'api.generator.talao.co',
            'generator.talao.co',
            'api.issuer.tezotopia.altme.io'
          ]
        }
      },
      'presentedAt': '2022-08-02T18:23:42.391937'
    }
  ]
};
