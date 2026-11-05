import 'dart:convert';
import 'dart:io';

import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:flutter_test/flutter_test.dart';

/// The QES attestation as stored, whose issuer metadata does not describe
/// any of its four disclosures.
CredentialModel _withoutDescribedClaims() {
  final json =
      jsonDecode(
            File(
              'test/dashboard/home/tab_bar/credentials/present/pick/'
              'dcql_query/fixtures/qes_attestation.json',
            ).readAsStringSync(),
          )
          as Map<String, dynamic>;
  final supported = Map<String, dynamic>.from(
    json['credentialSupported'] as Map,
  )..['credential_metadata'] = <String, dynamic>{};
  return CredentialModel.fromJson({...json, 'credentialSupported': supported});
}

void main() {
  group('SelectiveDisclosureDisplayMap', () {
    test('lists the disclosures the issuer metadata does not describe, '
        'outside a presentation', () {
      final map = SelectiveDisclosureDisplayMap(
        credentialModel: _withoutDescribedClaims(),
        isPresentation: false,
        languageCode: 'en',
        limitDisclosure: '',
        filters: const {},
        displayMode: false,
        selectedClaimsKeyIds: const [],
      ).buildMap;

      expect(
        map.keys,
        containsAll([
          'userName',
          'credentialID',
          'signatureQualifier',
          'certificateFingerprint',
        ]),
      );
    });
  });
}
