import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CredentialStatusField model', () {
    test('default constructor work correctly', () {
      final credentialStatusField = CredentialStatusField(
        'id',
        'type',
        'revocationListIndex',
        'revocationListCredential',
      );
      expect(credentialStatusField.id, 'id');
      expect(credentialStatusField.type, 'type');
      expect(credentialStatusField.revocationListIndex, 'revocationListIndex');
      expect(
        credentialStatusField.revocationListCredential,
        'revocationListCredential',
      );
    });

    test('fromJson constructor work correctly', () {
      final credentialStatusField = CredentialStatusField.fromJson(
        <String, dynamic>{
          'id': 'id',
          'type': 'type',
          'revocationListIndex': 'revocationListIndex',
          'revocationListCredential': 'revocationListCredential'
        },
      );
      expect(credentialStatusField.id, 'id');
      expect(credentialStatusField.type, 'type');
      expect(credentialStatusField.revocationListIndex, 'revocationListIndex');
      expect(
        credentialStatusField.revocationListCredential,
        'revocationListCredential',
      );
    });

    test('toJson constructor work correctly', () {
      final json = <String, dynamic>{
        'id': 'id',
        'type': 'type',
        'revocationListIndex': 'revocationListIndex',
        'revocationListCredential': 'revocationListCredential'
      };
      final credentialStatusField = CredentialStatusField.fromJson(json);

      expect(credentialStatusField.toJson(), json);
    });

    test('empty constructor work properly', () {
      final credentialStatusField =
          CredentialStatusField.emptyCredentialStatusField();
      expect(credentialStatusField.id, '');
      expect(credentialStatusField.type, '');
      expect(credentialStatusField.revocationListIndex, '');
      expect(credentialStatusField.revocationListCredential, '');
    });
  });
}
