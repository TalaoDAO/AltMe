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
        'statusListCredential',
        'statusListIndex',
        'statusPurpose',
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
      final credentialStatusField =
          CredentialStatusField.fromJson(<String, dynamic>{
            'id': '123',
            'type': 'type',
            'revocationListIndex': 'revocationListIndex',
            'revocationListCredential': 'revocationListCredential',
            'statusListCredential': 'statusListCredential',
            'statusListIndex': 'statusListIndex',
            'statusPurpose': 'statusPurpose',
          });
      expect(credentialStatusField.id, '123');
      expect(credentialStatusField.type, 'type');
      expect(credentialStatusField.revocationListIndex, 'revocationListIndex');
      expect(
        credentialStatusField.revocationListCredential,
        'revocationListCredential',
      );
      expect(
        credentialStatusField.statusListCredential,
        'statusListCredential',
      );
      expect(credentialStatusField.statusListIndex, 'statusListIndex');
      expect(credentialStatusField.statusPurpose, 'statusPurpose');
    });

    test('toJson constructor work correctly', () {
      final credentialStatusField = CredentialStatusField(
        'id',
        'type',
        'revocationListIndex',
        'revocationListCredential',
        'statusListCredential',
        'statusListIndex',
        'statusPurpose',
      );

      final json = credentialStatusField.toJson();

      expect(json['id'], 'id');
      expect(json['type'], 'type');
      expect(json['revocationListIndex'], 'revocationListIndex');
      expect(json['revocationListCredential'], 'revocationListCredential');
      expect(json['statusListCredential'], 'statusListCredential');
      expect(json['statusListIndex'], 'statusListIndex');
      expect(json['statusPurpose'], 'statusPurpose');
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
