// ignore_for_file: prefer_const_constructors
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CredentialManifest', () {
    test('can be instantiated', () {
      expect(
        CredentialManifest(
          'idOfCredentialManifest',
          null,
          [],
          null,
        ),
        isNotNull,
      );
    });
  });
}
