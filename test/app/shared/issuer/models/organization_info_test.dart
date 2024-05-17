import 'package:altme/app/shared/issuer/models/organization_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OrganizationInfo', () {
    test(
        'OrganizationInfo fromJson should return a valid OrganizationInfo object',
        () {
      final json = {
        'id': 'org-123',
        'legalName': 'Example Org',
        'currentAddress': '123 Street',
        'website': 'example.com',
        'issuerDomain': ['example.com'],
      };

      final organizationInfo = OrganizationInfo.fromJson(json);

      expect(organizationInfo.id, equals('org-123'));
      expect(organizationInfo.legalName, equals('Example Org'));
      expect(organizationInfo.currentAddress, equals('123 Street'));
      expect(organizationInfo.website, equals('example.com'));
      expect(organizationInfo.issuerDomain, equals(['example.com']));
    });

    test('OrganizationInfo toJson should return a valid JSON map', () {
      final organizationInfo = OrganizationInfo(
        id: 'org-123',
        legalName: 'Example Org',
        currentAddress: '123 Street',
        website: 'example.com',
        issuerDomain: ['example.com'],
      );

      final json = organizationInfo.toJson();

      expect(json['id'], equals('org-123'));
      expect(json['legalName'], equals('Example Org'));
      expect(json['currentAddress'], equals('123 Street'));
      expect(json['website'], equals('example.com'));
      expect(json['issuerDomain'], equals(['example.com']));
    });

    test(
        'OrganizationInfo.emptyOrganizationInfo should return an OrganizationInfo with default values',
        () {
      final organizationInfo =
          OrganizationInfo.emptyOrganizationInfo('example.com');

      expect(organizationInfo.id, equals(''));
      expect(organizationInfo.legalName, equals(''));
      expect(organizationInfo.currentAddress, equals(''));
      expect(organizationInfo.website, equals('example.com'));
      expect(organizationInfo.issuerDomain, isEmpty);
    });
  });
}
