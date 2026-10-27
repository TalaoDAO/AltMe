import 'dart:convert';

import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/oidc4vc/helper_function/mdoc_credential_data.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform_p256_keys/platform_p256_keys.dart';

import '../oidc4vc/support/issuer_signed_fixture.dart';

class _MockPlatformP256Keys extends Mock implements PlatformP256Keys {}

class _MockCredential extends Mock implements Credential {}

void main() {
  late CredentialModel mdoc;

  setUp(() async {
    final data = await getMdocCredentialData(
      issuerSigned: testIssuerSigned(),
      credentialType: 'eu.europa.ec.eudi.pid_mdoc',
      platformKeys: _MockPlatformP256Keys(),
    );
    mdoc = CredentialModel(
      id: 'pid',
      image: '',
      shareLink: '',
      data: data,
      credentialPreview: _MockCredential(),
      format: 'mso_mdoc',
      // decoded from JSON, as issuer metadata reaches the app
      credentialSupported:
          jsonDecode('''
{
  "format": "mso_mdoc",
  "credential_metadata": {
    "claims": [
      {"path": ["$mdlNameSpace", "family_name"],
       "display": [{"locale": "en", "name": "Family Name"}]},
      {"path": ["$mdlNameSpace", "age_over_18"],
       "display": [{"locale": "en", "name": "Over 18"}]}
    ]
  }
}''')
              as Map<String, dynamic>,
    );
  });

  group('SelectiveDisclosure for mso_mdoc', () {
    test('builds the claims tree from [namespace, element] paths', () {
      final claims = SelectiveDisclosure(mdoc).claims;

      expect(claims.keys, [mdlNameSpace]);
      expect((claims[mdlNameSpace] as Map).keys, [
        'family_name',
        'age_over_18',
      ]);
    });

    test('reads values from the credential data, without a JWT', () {
      final (claimsData, sd) = SelectiveDisclosure(
        mdoc,
      ).getClaimsData(key: 'family_name', parentKeyId: mdlNameSpace);

      expect(claimsData.single.data, 'Doe');
      expect(sd, isNull);
    });

    test('display map lists every element under its display name', () {
      final map = SelectiveDisclosureDisplayMap(
        credentialModel: mdoc,
        isPresentation: false,
        languageCode: 'en',
        limitDisclosure: '',
        filters: const {},
        isDeveloperMode: false,
        displayMode: false,
        selectedClaimsKeyIds: const [],
      ).buildMap;

      final nameSpace = map.values.single as Map<String, dynamic>;
      final elements = nameSpace['value'] is Map
          ? nameSpace['value'] as Map<String, dynamic>
          : nameSpace;
      expect(elements['Family Name']['value'], 'Doe');
      expect(elements['Over 18']['value'], isTrue);
    });
  });
}
