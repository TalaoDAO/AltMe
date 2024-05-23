import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/issuer/models/organization_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/mockito.dart';
import 'package:secure_storage/secure_storage.dart';

class MockSecureStorage extends Mock implements SecureStorageProvider {}

void main() {
  group('CheckIssuer', () {
    late SecureStorageProvider mockSecureStorage;

    final client = Dio();
    late DioAdapter dioAdapter;
    late DioClient mockClient;

    late CheckIssuer checkIssuer;

    const String checkIssuerServerUrl = 'https://example.com';
    final Uri uriToCheck = Uri.parse('https://example.com');

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      mockSecureStorage = MockSecureStorage();

      dioAdapter = DioAdapter(
          dio: Dio(BaseOptions()), matcher: const UrlRequestMatcher(),);
      client.httpClientAdapter = dioAdapter;
      mockClient = DioClient(
        baseUrl: 'https://example.com/',
        secureStorageProvider: mockSecureStorage,
        dio: client,
      );
      checkIssuer = CheckIssuer(
        mockClient,
        checkIssuerServerUrl,
        uriToCheck,
      );
    });

    test('should return empty issuer if checkIssuerServerUrl is empty',
        () async {
      final checkIssuer = CheckIssuer(
        mockClient,
        '',
        uriToCheck,
      );

      final result = await checkIssuer.isIssuerInApprovedList();

      expect(
        jsonEncode(result),
        equals(jsonEncode(Issuer.emptyIssuer(uriToCheck.host))),
      );
    });

    test('should return empty issuer if did does not start with did:ebsi',
        () async {
      final checkIssuer = CheckIssuer(
        mockClient,
        Urls.checkIssuerEbsiUrl,
        Uri.parse('https://example.com'),
      );

      final result = await checkIssuer.isIssuerInApprovedList();

      expect(
        jsonEncode(result),
        equals(jsonEncode(Issuer.emptyIssuer('example.com'))),
      );
    });

    test(
        'should return specific issuer for'
        ' https://api.conformance.intebsi.xyz/trusted-issuers-registry/v2/issuers',
        () async {
      final checkIssuer = CheckIssuer(
        mockClient,
        'https://api.conformance.intebsi.xyz/trusted-issuers-registry/v2/issuers',
        Uri.parse('https://example.com?issuer=did:ebsi'),
      );

      final result = await checkIssuer.isIssuerInApprovedList();

      final expected = Issuer(
        preferredName: '',
        did: [],
        organizationInfo: OrganizationInfo(
          legalName: 'sdf',
          currentAddress: '',
          id: '',
          issuerDomain: [],
          website: uriToCheck.host,
        ),
      );

      expect(
        jsonEncode(result),
        equals(jsonEncode(expected)),
      );
    });

    test('should return valid issuer when issuer is in approved list',
        () async {
      final response = {
        'issuer': {
          'preferredName': 'Example Issuer',
          'did': ['did:example:123'],
          'organizationInfo': {
            'legalName': 'Example Org',
            'currentAddress': '123 Street',
            'id': 'org-123',
            'issuerDomain': ['example.com'],
            'website': 'example.com',
          },
        },
      };

      dioAdapter.onGet(
        'https://example.com/',
        (request) => request.reply(200, response),
      );

      final result = await checkIssuer.isIssuerInApprovedList();

      expect(result.preferredName, equals('Example Issuer'));
      expect(result.organizationInfo.legalName, equals('Example Org'));
      expect(result.organizationInfo.issuerDomain, contains('example.com'));
    });

    test(
        // ignore: lines_longer_than_80_chars
        'should return empty issuer if organizationInfo.issuerDomain does not contain uriToCheck.host',
        () async {
      final response = {
        'issuer': {
          'preferredName': 'Example Issuer',
          'did': ['did:example:123'],
          'organizationInfo': {
            'legalName': 'Example Org',
            'currentAddress': '123 Street',
            'id': 'org-123',
            'issuerDomain': ['another.com'],
            'website': 'example.com',
          },
        },
      };

      dioAdapter.onGet(
        'https://example.com/',
        (request) => request.reply(200, response),
      );

      final result = await checkIssuer.isIssuerInApprovedList();

      expect(jsonEncode(result),
          equals(jsonEncode(Issuer.emptyIssuer(uriToCheck.host))),);
    });

    test('should throw exception when an error occurs', () async {
      expect(
        () async => checkIssuer.isIssuerInApprovedList(),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
