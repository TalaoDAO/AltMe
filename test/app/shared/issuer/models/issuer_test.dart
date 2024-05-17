import 'package:altme/app/app.dart';
import 'package:altme/app/shared/issuer/models/organization_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Issuer', () {
    test('Issuer fromJson should return a valid Issuer object', () {
      final json = {
        'preferredName': 'Example Issuer',
        'did': ['did:example:123'],
        'organizationInfo': {
          'id': 'org-123',
          'legalName': 'Example Org',
          'currentAddress': '123 Street',
          'website': 'example.com',
          'issuerDomain': ['example.com'],
        },
      };

      final issuer = Issuer.fromJson(json);

      expect(issuer.preferredName, equals('Example Issuer'));
      expect(issuer.did, equals(['did:example:123']));
      expect(issuer.organizationInfo.id, equals('org-123'));
      expect(issuer.organizationInfo.legalName, equals('Example Org'));
      expect(issuer.organizationInfo.currentAddress, equals('123 Street'));
      expect(issuer.organizationInfo.website, equals('example.com'));
      expect(issuer.organizationInfo.issuerDomain, equals(['example.com']));
    });

    test('Issuer toJson should return a valid JSON map', () {
      final organizationInfo = OrganizationInfo(
        id: 'org-123',
        legalName: 'Example Org',
        currentAddress: '123 Street',
        website: 'example.com',
        issuerDomain: ['example.com'],
      );

      final issuer = Issuer(
        preferredName: 'Example Issuer',
        did: ['did:example:123'],
        organizationInfo: organizationInfo,
      );

      final json = issuer.toJson();

      expect(json['preferredName'], equals('Example Issuer'));
      expect(json['did'], equals(['did:example:123']));
      expect(json['organizationInfo'], isA<OrganizationInfo>());
    });

    test('Issuer.emptyIssuer should return an Issuer with default values', () {
      final issuer = Issuer.emptyIssuer('example.com');

      expect(issuer.preferredName, equals(''));
      expect(issuer.did, isEmpty);
      expect(issuer.organizationInfo.id, equals(''));
      expect(issuer.organizationInfo.legalName, equals(''));
      expect(issuer.organizationInfo.currentAddress, equals(''));
      expect(issuer.organizationInfo.website, equals('example.com'));
      expect(issuer.organizationInfo.issuerDomain, isEmpty);
    });
  });
}
