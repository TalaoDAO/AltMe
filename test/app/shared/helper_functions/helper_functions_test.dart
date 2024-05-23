import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/home.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:key_generator/key_generator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

class MockSecureStorage extends Mock implements SecureStorageProvider {}

class MockDotenv extends Mock implements DotEnv {}

void main() {
  late SecureStorageProvider mockSecureStorage;

  final client = Dio();
  late DioAdapter dioAdapter;
  late DioClient mockClient;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockSecureStorage = MockSecureStorage();

    dioAdapter =
        DioAdapter(dio: Dio(BaseOptions()), matcher: const UrlRequestMatcher());
    client.httpClientAdapter = dioAdapter;
    mockClient = DioClient(
      baseUrl: 'https://example.com/',
      secureStorageProvider: mockSecureStorage,
      dio: client,
    );
  });

  group('HelperFunctions', () {
    group('generateDefaultAccountName', () {
      test('Should generate default account name', () {
        expect(generateDefaultAccountName(0, []), 'My account 1');
        expect(generateDefaultAccountName(1, []), 'My account 2');
        expect(generateDefaultAccountName(2, []), 'My account 3');
      });

      test('Should generate unique default account name', () {
        final accountNameList = ['My account 1', 'My account 2'];
        expect(generateDefaultAccountName(0, accountNameList), 'My account 3');
      });

      test('Should handle existing default account name', () {
        final accountNameList = [
          'My account 1',
          'My account 2',
          'My account 3',
        ];
        expect(generateDefaultAccountName(0, accountNameList), 'My account 4');
      });
    });

    group('Platform checks', () {
      test('isAndroid should return true on Android platform', () {
        expect(isAndroid, false);
      });

      test('isIOS should return true on iOS platform', () {
        expect(isIOS, false);
      });
    });

    group('getIssuerDid', () {
      test('Should return empty string if no issuer in URI', () {
        final uri = Uri.parse('https://example.com');
        expect(getIssuerDid(uriToCheck: uri), '');
      });

      test('Should return issuer DID if present in URI', () {
        final uri = Uri.parse('https://example.com?issuer=did:example');
        expect(getIssuerDid(uriToCheck: uri), 'did:example');
      });

      test('Should return last issuer DID if multiple issuers in URI', () {
        final uri = Uri.parse(
          'https://example.com?issuer=did:example1&issuer=did:example2',
        );
        expect(getIssuerDid(uriToCheck: uri), 'did:example2');
      });
    });

    group('isValidPrivateKey', () {
      test('Should return true for valid Ethereum private key', () {
        const validKey =
            // ignore: lines_longer_than_80_chars
            '0x0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef';
        expect(isValidPrivateKey(validKey), true);
      });

      test('Should return true for valid Tezos private key (edsk)', () {
        const validKey =
            'edsk3nLLjZzUtwUmBzJbry8MZx8YmPfEzZaCFpSSKmCWUz1k5ehSJ8';
        expect(isValidPrivateKey(validKey), true);
      });

      test('Should return false for invalid private key', () {
        const invalidKey = 'invalid_private_key';
        expect(isValidPrivateKey(invalidKey), false);
      });
    });

    test('stringToHexPrefixedWith05 returns correct value', () {
      const payload = 'Bibash';
      expect(
        stringToHexPrefixedWith05(
          payload: payload,
          dateTime: DateTime(2022, 1, 1, 0, 0, 0, 0),
        ),
        // ignore: lines_longer_than_80_chars
        '05010031323254657a6f73205369676e6564204d6573736167653a20616c746d652e696f20323032322d30312d30312030303a30303a30302e30303020426962617368',
      );
    });

    test('getCredentialName returns correct credential name', () {
      const constraints = {
        'fields': [
          {
            'path': r'[$.credentialSubject.type]',
            'filter': {'pattern': 'Bibash'},
          },
        ],
      };

      final result = getCredentialName(jsonEncode(constraints));
      expect(result, equals('Bibash'));
    });

    test('getIssuersName returns correct issuer name', () {
      const constraints = {
        'fields': [
          {
            'path': r'[$.issuer]',
            'filter': {'pattern': 'Bibash'},
          },
        ],
      };

      final result = getIssuersName(jsonEncode(constraints));
      expect(result, equals('Bibash'));
    });

    test('getBlockchainType returns correct issuer name', () {
      expect(
        getBlockchainType(AccountType.tezos),
        equals(BlockchainType.tezos),
      );
      expect(
        getBlockchainType(AccountType.ethereum),
        equals(BlockchainType.ethereum),
      );
      expect(
        getBlockchainType(AccountType.fantom),
        equals(BlockchainType.fantom),
      );
      expect(
        getBlockchainType(AccountType.polygon),
        equals(BlockchainType.polygon),
      );
      expect(
        getBlockchainType(AccountType.binance),
        equals(BlockchainType.binance),
      );
      expect(
        () => getBlockchainType(AccountType.ssi),
        throwsA(isA<ResponseMessage>()),
      );
    });

    test('getCredTypeFromName returns correct type', () {
      expect(
        getCredTypeFromName('DefiCompliance'),
        equals(CredentialSubjectType.defiCompliance),
      );
      expect(getCredTypeFromName('afsd'), equals(isNull));
    });

    test('timeFormatter formats time correctly', () {
      expect(timeFormatter(timeInSecond: 65), equals('01 : 05'));
      expect(timeFormatter(timeInSecond: 3600), equals('60 : 00'));
      expect(timeFormatter(timeInSecond: 3665), equals('61 : 05'));
      expect(timeFormatter(timeInSecond: 0), equals('00 : 00'));
    });

    test('getssiMnemonicsInList returns list of words', () async {
      const mockMnemonic =
          // ignore: lines_longer_than_80_chars
          'word1 word2 word3 word4 word5 word6 word7 word8 word9 word10 word11 word12';

      when(() => mockSecureStorage.get(SecureStorageKeys.ssiMnemonic))
          .thenAnswer((_) => Future.value(mockMnemonic));

      final result = await getssiMnemonicsInList(mockSecureStorage);

      expect(
        result,
        containsAll([
          'word1',
          'word2',
          'word3',
          'word4',
          'word5',
          'word6',
          'word7',
          'word8',
          'word9',
          'word10',
          'word11',
          'word12',
        ]),
      );
    });

    test('getDateTimeWithoutSpace replaces spaces with dashes', () {
      final formattedDateTime =
          getDateTimeWithoutSpace(dateTime: DateTime(2022, 1, 1, 1, 1, 1, 1));
      expect(formattedDateTime, '2022-01-01-01:01:01.001');
    });

    test('getIndexValue returns correct index for each DidKeyType', () {
      expect(
        getIndexValue(isEBSIV3: true, didKeyType: DidKeyType.secp256k1),
        3,
      );
      expect(
        getIndexValue(isEBSIV3: false, didKeyType: DidKeyType.secp256k1),
        1,
      );

      expect(getIndexValue(isEBSIV3: false, didKeyType: DidKeyType.p256), 4);
      expect(getIndexValue(isEBSIV3: false, didKeyType: DidKeyType.ebsiv3), 5);
      expect(getIndexValue(isEBSIV3: false, didKeyType: DidKeyType.jwkP256), 6);
      expect(getIndexValue(isEBSIV3: false, didKeyType: DidKeyType.edDSA), 0);
      expect(
        getIndexValue(
          isEBSIV3: false,
          didKeyType: DidKeyType.jwtClientAttestation,
        ),
        0,
      );
    });

    group('getWalletAttestationP256Key', () {
      test('returns existing key', () async {
        const existingKey = 'existing_key';
        when(
          () =>
              mockSecureStorage.get(SecureStorageKeys.p256PrivateKeyForWallet),
        ).thenAnswer((_) => Future.value(existingKey));

        final result = await getWalletAttestationP256Key(mockSecureStorage);

        expect(result, existingKey.replaceAll('=', ''));
      });

      test('generates and returns new key', () async {
        when(
          () =>
              mockSecureStorage.get(SecureStorageKeys.p256PrivateKeyForWallet),
        ).thenAnswer((_) => Future.value(null));

        when(() => mockSecureStorage.set(any(), any()))
            .thenAnswer((_) async {});

        final result = await getWalletAttestationP256Key(mockSecureStorage);
        final data = jsonDecode(result) as Map<String, dynamic>;

        expect(data['alg'], 'ES256');
        expect(data['crv'], 'P-256');
        expect(data['d'], isA<String>());
        expect(data['kty'], 'EC');
        expect(data['use'], 'sig');
        expect(data['x'], isA<String>());
        expect(data['y'], isA<String>());
      });
    });

    group('getP256KeyToGetAndPresentVC', () {
      test('returns existing key', () async {
        const existingKey = 'existing_key';
        when(
          () => mockSecureStorage
              .get(SecureStorageKeys.p256PrivateKeyToGetAndPresentVC),
        ).thenAnswer((_) => Future.value(existingKey));

        final result = await getP256KeyToGetAndPresentVC(mockSecureStorage);

        expect(result, existingKey.replaceAll('=', ''));
      });

      test('generates and returns new key', () async {
        when(
          () => mockSecureStorage
              .get(SecureStorageKeys.p256PrivateKeyToGetAndPresentVC),
        ).thenAnswer((_) => Future.value(null));

        when(() => mockSecureStorage.set(any(), any()))
            .thenAnswer((_) async {});

        final result = await getP256KeyToGetAndPresentVC(mockSecureStorage);
        final data = jsonDecode(result) as Map<String, dynamic>;

        expect(data['alg'], 'ES256');
        expect(data['crv'], 'P-256');
        expect(data['d'], isA<String>());
        expect(data['kty'], 'EC');
        expect(data['use'], 'sig');
        expect(data['x'], isA<String>());
        expect(data['y'], isA<String>());
      });
    });

    test('generateRandomP256Key returns a valid P-256 key', () {
      final key = generateRandomP256Key();

      final data = jsonDecode(key) as Map<String, dynamic>;

      expect(data['alg'], 'ES256');
      expect(data['crv'], 'P-256');
      expect(data['d'], isA<String>());
      expect(data['kty'], 'EC');
      expect(data['use'], 'sig');
      expect(data['x'], isA<String>());
      expect(data['y'], isA<String>());
    });

    test('getDidKeyFromString returns correct enum value', () {
      expect(getDidKeyFromString('DidKeyType.edDSA'), DidKeyType.edDSA);
      expect(getDidKeyFromString('DidKeyType.secp256k1'), DidKeyType.secp256k1);
      expect(getDidKeyFromString('DidKeyType.p256'), DidKeyType.p256);
      expect(getDidKeyFromString('DidKeyType.ebsiv3'), DidKeyType.ebsiv3);
      expect(getDidKeyFromString('DidKeyType.jwkP256'), DidKeyType.jwkP256);
      expect(
        getDidKeyFromString('DidKeyType.jwtClientAttestation'),
        DidKeyType.jwtClientAttestation,
      );
      expect(getDidKeyFromString('InvalidKeyType'), null);
      expect(getDidKeyFromString(null), null);
    });

    group('JWT Decode Payload and Header', () {
      final jwtDecode = JWTDecode();

      const jwt =
          // ignore: lines_longer_than_80_chars
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFt'
          // ignore: lines_longer_than_80_chars
          'ZSI6IkJpYmFzaCIsImlhdCI6MTUxNjIzOTAyMn0.ILWacv8Ed_PmWsLBEIK1mM-wOrt4w'
          'AU7_OUNLXQqtwI';

      test('decodePayload correctly decodes a JWT token', () {
        final decodedData = decodePayload(jwtDecode: jwtDecode, token: jwt);
        final expectedData = {
          'sub': '1234567890',
          'name': 'Bibash',
          'iat': 1516239022,
        };
        expect(decodedData, expectedData);
      });

      test('decodeHeader correctly decodes a JWT token', () {
        final decodedData = decodeHeader(jwtDecode: jwtDecode, token: jwt);
        final expectedData = {
          'alg': 'HS256',
          'typ': 'JWT',
        };
        expect(decodedData, expectedData);
      });

      test('birthDateFormater formats the birth date correctly', () {
        const birthData = 19900101;
        final formattedBirthdate = birthDateFormater(birthData);

        expect(formattedBirthdate, '1990-01-01');
      });

      test('getSignatureType returns correct signature type for circuitId', () {
        expect(getSignatureType('credentialAtomicQuerySigV2'), 'BJJ Signature');
        expect(
          getSignatureType('credentialAtomicQuerySigV2OnChain'),
          'BJJ Signature',
        );
        expect(getSignatureType('credentialAtomicQueryMTPV2'), 'SMT Signature');
        expect(
          getSignatureType('credentialAtomicQueryMTPV2OnChain'),
          'SMT Signature',
        );
        expect(getSignatureType('unknownCircuitId'), '');
      });

      test('splitUppercase splits PascalCase string correctly', () {
        const input = 'BibashManShrestha';
        final result = splitUppercase(input);
        expect(result, 'Bibash Man Shrestha');
      });

      test('generateUriList returns list of URIs from "uri_list" parameter',
          () {
        const url =
            'https://example.com?uri_list=https%3A%2F%2Fexample.com%2Fpath1&uri_list=https%3A%2F%2Fexample.com%2Fpath2';
        final result = generateUriList(url);
        expect(
          result,
          ['https://example.com/path1', 'https://example.com/path2'],
        );
      });

      test('sortedPublcJwk returns sorted public JWK without private key', () {
        final privateKey = {
          'kty': 'EC',
          'use': 'sig',
          'crv': 'P-256K',
          'kid': '1234567890',
          'x': 'SjTww7i4eF-JKBYlShJqJ3lWQIVJF5y1g5uHY3gfAro',
          'y': '1bNb6uA0gKClEFhodSfgcW8FvfSHTgxE8WyFvSZ8bxc',
        };
        final result = sortedPublcJwk(jsonEncode(privateKey));
        const expected =
            // ignore: lines_longer_than_80_chars
            '{"crv":"secp256k1","kid":"1234567890","kty":"EC","x":"SjTww7i4eF-JKBYlShJqJ3lWQIVJF5y1g5uHY3gfAro","y":"1bNb6uA0gKClEFhodSfgcW8FvfSHTgxE8WyFvSZ8bxc"}';
        expect(result, expected);
      });

      test('isPolygonIdUrl returns correct value for valid Polygon ID URLs',
          () {
        expect(isPolygonIdUrl('{"id":'), true);
        expect(isPolygonIdUrl('{"body":{"'), true);
        expect(isPolygonIdUrl('{"from": "did:polygonid:'), true);
        expect(isPolygonIdUrl('{"to": "did:polygonid:'), true);
        expect(isPolygonIdUrl('{"thid":'), true);
        expect(isPolygonIdUrl('{"typ":'), true);
        expect(isPolygonIdUrl('{"type":'), true);
      });

      test('isOIDC4VCIUrl returns true for valid OIDC4VCI URLs', () {
        expect(isOIDC4VCIUrl(Uri.parse('openid://some/path')), true);
        expect(isOIDC4VCIUrl(Uri.parse('haip://another/path')), true);
      });

      group('handleErrorForOID4VCI throws correct errors', () {
        test('Test tokenEndpoint is null', () {
          expect(
            () async => handleErrorForOID4VCI(
              url: 'example',
              openIdConfiguration: const OpenIdConfiguration(
                authorizationServer: 'example',
                tokenEndpoint: null,
              ),
              authorizationServerConfiguration: const OpenIdConfiguration(
                tokenEndpoint: null,
              ),
            ),
            throwsA(
              isA<ResponseMessage>().having((e) => e.data, '', {
                'error': 'invalid_issuer_metadata',
                'error_description': 'The issuer configuration is invalid. '
                    'The token_endpoint is missing.',
              }),
            ),
          );
        });

        test('Test credentialEndpoint is null', () {
          expect(
            () async => handleErrorForOID4VCI(
              url: 'example',
              openIdConfiguration: const OpenIdConfiguration(
                authorizationServer: 'example',
                tokenEndpoint: null,
                credentialEndpoint: null,
              ),
              authorizationServerConfiguration: const OpenIdConfiguration(
                tokenEndpoint: 'https://example.com/token',
              ),
            ),
            throwsA(
              isA<ResponseMessage>().having((e) => e.data, '', {
                'error': 'invalid_issuer_metadata',
                'error_description': 'The issuer configuration is invalid. '
                    'The credential_endpoint is missing.',
              }),
            ),
          );
        });

        test('Test credentialIssuer is null', () {
          expect(
            () async => handleErrorForOID4VCI(
              url: 'example',
              openIdConfiguration: const OpenIdConfiguration(
                authorizationServer: 'example',
                tokenEndpoint: null,
                credentialEndpoint: 'https://example.com/cred',
                credentialIssuer: null,
              ),
              authorizationServerConfiguration: const OpenIdConfiguration(
                tokenEndpoint: 'https://example.com/token',
              ),
            ),
            throwsA(
              isA<ResponseMessage>().having((e) => e.data, '', {
                'error': 'invalid_issuer_metadata',
                'error_description': 'The issuer configuration is invalid. '
                    'The credential_issuer is missing.',
              }),
            ),
          );
        });

        test(
            // ignore: lines_longer_than_80_chars
            'Test credentialsSupported and credentialConfigurationsSupported are null',
            () {
          expect(
            () async => handleErrorForOID4VCI(
              url: 'example',
              openIdConfiguration: const OpenIdConfiguration(
                authorizationServer: 'example',
                tokenEndpoint: null,
                credentialEndpoint: 'https://example.com/cred',
                credentialIssuer: 'issuer',
                credentialsSupported: null,
                credentialConfigurationsSupported: null,
              ),
              authorizationServerConfiguration: const OpenIdConfiguration(
                tokenEndpoint: 'https://example.com/token',
              ),
            ),
            throwsA(
              isA<ResponseMessage>().having((e) => e.data, '', {
                'error': 'invalid_issuer_metadata',
                'error_description': 'The issuer configuration is invalid. '
                    'The credentials_supported is missing.',
              }),
            ),
          );
        });

        test(
            // ignore: lines_longer_than_80_chars
            'Test credentialsSupported and credentialConfigurationsSupported are null',
            () {
          expect(
            () async => handleErrorForOID4VCI(
              url: 'example',
              openIdConfiguration: const OpenIdConfiguration(
                authorizationServer: 'example',
                tokenEndpoint: null,
                credentialEndpoint: 'https://example.com/cred',
                credentialIssuer: 'issuer',
                credentialsSupported: null,
                credentialConfigurationsSupported: 'asdf',
                subjectSyntaxTypesSupported: ['asd'],
              ),
              authorizationServerConfiguration: const OpenIdConfiguration(
                tokenEndpoint: 'https://example.com/token',
              ),
            ),
            throwsA(
              isA<ResponseMessage>().having((e) => e.data, '', {
                'error': 'subject_syntax_type_not_supported',
                'error_description':
                    'The subject syntax type is not supported.',
              }),
            ),
          );
        });
      });

      group('getPresentationDefinition', () {
        test('returns presentation definition from URI', () async {
          final uri = Uri.parse(
            "https://example.com?presentation_definition={'title':'Test'}",
          );
          final presentationDefinition =
              await getPresentationDefinition(uri: uri, client: mockClient);

          expect(presentationDefinition, {'title': 'Test'});
        });

        test('returns null for invalid URI', () async {
          final uri = Uri.parse('https://example.com');
          final presentationDefinition =
              await getPresentationDefinition(uri: uri, client: mockClient);

          expect(presentationDefinition, isNull);
        });

        test(
            'returns presentation definition from URI with '
            'presentation_definition_uri', () async {
          final uri = Uri.parse(
            'https://example.com?presentation_definition_uri=https://example.com/presentation.com',
          );

          dioAdapter.onGet(
            'https://example.com/presentation.com',
            (request) => request.reply(200, {'title': 'Test'}),
          );

          final presentationDefinition =
              await getPresentationDefinition(uri: uri, client: mockClient);

          expect(presentationDefinition, {'title': 'Test'});
        });

        test('returns null for invalid presentation_definition_uri', () async {
          final uri = Uri.parse(
            'https://example.com?presentation_definition_uri=https://example.com/presentation.com',
          );

          dioAdapter.onGet(
            'https://example.com/presentation.com',
            (request) => request.reply(200, 'asfd'),
          );

          final presentationDefinition =
              await getPresentationDefinition(uri: uri, client: mockClient);

          expect(presentationDefinition, isNull);
        });
      });

      group('getClientMetada', () {
        test('returns client metadata from URI', () async {
          final uri =
              Uri.parse("https://example.com?client_metadata={'title':'Test'}");
          final clientMetadata =
              await getClientMetada(uri: uri, client: mockClient);

          expect(clientMetadata, {'title': 'Test'});
        });

        test('returns null for invalid URI', () async {
          final uri = Uri.parse('https://example.com');
          final clientMetadata =
              await getClientMetada(uri: uri, client: mockClient);

          expect(clientMetadata, isNull);
        });

        test(
            'returns client metadata from URI with '
            'client_metadata_uri', () async {
          final uri = Uri.parse(
            'https://example.com?client_metadata_uri=https://example.com.com',
          );

          dioAdapter.onGet(
            'https://example.com.com',
            (request) => request.reply(200, {'title': 'Test'}),
          );

          final clientMetadata =
              await getClientMetada(uri: uri, client: mockClient);

          expect(clientMetadata, {'title': 'Test'});
        });

        test('returns null for invalid client_metadata_uri', () async {
          final uri = Uri.parse(
            'https://example.com?client_metadata_uri=https://example.com.com',
          );

          dioAdapter.onGet(
            'https://example.com.com',
            (request) => request.reply(200, 'asfd'),
          );

          expect(
            () async => getClientMetada(uri: uri, client: mockClient),
            throwsA(
              isA<ResponseMessage>().having((e) => e.data, '', {
                'error': 'invalid_request',
                'error_description': 'Client metaData is invalid',
              }),
            ),
          );
        });
      });

      group('getCredentialData', () {
        test('getCredentialData returns credential if it is a String', () {
          const credential = 'credentialData';
          final result = getCredentialData(credential);
          expect(result, equals(credential));
        });

        test('getCredentialData returns last credential type if it is a Map',
            () {
          final credential = {
            'types': ['type1', 'type2', 'type3'],
          };
          final result = getCredentialData(credential);
          expect(result, equals('type3'));
        });

        test('getCredentialData throws exception for invalid credential format',
            () {
          const credential = 123;
          expect(() => getCredentialData(credential), throwsException);
        });

        test('getMessageHandler returns correct MessageHandler', () {
          expect(getMessageHandler(MessageHandler), isA<MessageHandler>());
          expect(
            getMessageHandler(
              DioException(
                requestOptions: RequestOptions(path: 'test/path'),
                error: 'Test error',
                response: Response(
                  data: 'Test data',
                  statusCode: 400,
                  requestOptions: RequestOptions(),
                ),
              ),
            ),
            isA<NetworkException>(),
          );
          expect(
            getMessageHandler(
              const FormatException('Test format exception', 'source'),
            ),
            isA<ResponseMessage>().having((e) => e.data, '', {
              'error': 'unsupported_format',
              'error_description': 'Test format exception\n'
                  '\n'
                  'source',
            }),
          );
          expect(
            getMessageHandler(TypeError()),
            isA<ResponseMessage>().having((e) => e.data, '', {
              'error': 'unsupported_format',
              'error_description':
                  'Some issue in the response from the server.',
            }),
          );
          expect(
            getMessageHandler('Exception: CREDENTIAL_SUPPORT_DATA_ERROR'),
            isA<ResponseMessage>().having((e) => e.data, '', {
              'error': 'unsupported_credential_format',
              'error_description':
                  'The credential support format has some issues.',
            }),
          );
          expect(
            getMessageHandler('Exception: AUTHORIZATION_DETAIL_ERROR'),
            isA<ResponseMessage>().having((e) => e.data, '', {
              'error': 'unsupported_format',
              'error_description': 'Invalid token response format.',
            }),
          );
          expect(
            getMessageHandler('Exception: INVALID_TOKEN'),
            isA<ResponseMessage>().having((e) => e.data, '', {
              'error': 'invalid_format',
              'error_description': 'Failed to extract header from jwt.',
            }),
          );
          expect(
            getMessageHandler('Exception: INVALID_PAYLOAD'),
            isA<ResponseMessage>().having((e) => e.data, '', {
              'error': 'invalid_format',
              'error_description': 'Failed to extract payload from jwt.',
            }),
          );
          expect(
            getMessageHandler('Exception: SSI_ISSUE'),
            isA<ResponseMessage>().having((e) => e.data, '', {
              'error': 'invalid_format',
              'error_description': 'SSI does not support this process.',
            }),
          );
          expect(
            getMessageHandler('Exception: OPENID-CONFIGURATION-ISSUE'),
            isA<ResponseMessage>().having((e) => e.data, '', {
              'error': 'unsupported_format',
              'error_description': 'Openid configuration response issue.',
            }),
          );
          expect(
            getMessageHandler('Exception: NOT_A_VALID_OPENID_URL'),
            isA<ResponseMessage>().having((e) => e.data, '', {
              'error': 'unsupported_format',
              'error_description':
                  'Not a valid openid url to initiate issuance.',
            }),
          );
          expect(
            getMessageHandler('Exception: JWKS_URI_IS_NULL'),
            isA<ResponseMessage>().having((e) => e.data, '', {
              'error': 'unsupported_format',
              'error_description': 'The jwks_uri is null.',
            }),
          );
          expect(
            getMessageHandler('Exception: Issue while getting'),
            isA<ResponseMessage>().having((e) => e.data, '', {
              'error': 'invalid_request',
              'error_description': 'Issue while getting',
            }),
          );
          expect(
            getMessageHandler('Exception: SECURE_STORAGE_ISSUE'),
            isA<ResponseMessage>().having((e) => e.data, '', {
              'error': 'invalid_request',
              'error_description': 'Secure Storage issue with this device',
            }),
          );
          expect(
            getMessageHandler('Exception: ISSUE_WHILE_ADDING_IDENTITY'),
            isA<ResponseMessage>().having((e) => e.data, '', {
              'error': 'invalid_request',
              'error_description': 'Issue while adding identity.',
            }),
          );
          expect(
            getMessageHandler('Exception: ISSUE_WHILE_GETTING_CLAIMS'),
            isA<ResponseMessage>().having((e) => e.data, '', {
              'error': 'invalid_request',
              'error_description': 'Issue while getting claims.',
            }),
          );
          expect(
            getMessageHandler('Exception: ISSUE_WHILE_RESTORING_CLAIMS'),
            isA<ResponseMessage>().having((e) => e.data, '', {
              'error': 'invalid_request',
              'error_description': 'Issue while restoring claims.',
            }),
          );
          expect(
            getMessageHandler('Exception: PUBLICKEYJWK_EXTRACTION_ERROR'),
            isA<ResponseMessage>().having((e) => e.data, '', {
              'error': 'invalid_request',
              'error_description': 'Issue while restoring claims.',
            }),
          );
          expect(
            getMessageHandler('Exception: random'),
            isA<ResponseMessage>(),
          );
        });

        test('getErrorResponseString returns correct ResponseString', () {
          expect(
            getErrorResponseString('invalid_request'),
            ResponseString.RESPONSE_STRING_invalidRequest,
          );
          expect(
            getErrorResponseString('invalid_request_uri'),
            ResponseString.RESPONSE_STRING_invalidRequest,
          );
          expect(
            getErrorResponseString('invalid_request_object'),
            ResponseString.RESPONSE_STRING_invalidRequest,
          );

          expect(
            getErrorResponseString('unauthorized_client'),
            ResponseString.RESPONSE_STRING_accessDenied,
          );
          expect(
            getErrorResponseString('access_denied'),
            ResponseString.RESPONSE_STRING_accessDenied,
          );
          expect(
            getErrorResponseString('invalid_or_missing_proof'),
            ResponseString.RESPONSE_STRING_accessDenied,
          );
          expect(
            getErrorResponseString('interaction_required'),
            ResponseString.RESPONSE_STRING_accessDenied,
          );

          expect(
            getErrorResponseString('unsupported_response_type'),
            ResponseString.RESPONSE_STRING_thisRequestIsNotSupported,
          );
          expect(
            getErrorResponseString('invalid_scope'),
            ResponseString.RESPONSE_STRING_thisRequestIsNotSupported,
          );
          expect(
            getErrorResponseString('request_not_supported'),
            ResponseString.RESPONSE_STRING_thisRequestIsNotSupported,
          );
          expect(
            getErrorResponseString('request_uri_not_supported'),
            ResponseString.RESPONSE_STRING_thisRequestIsNotSupported,
          );

          expect(
            getErrorResponseString('unsupported_credential_type'),
            ResponseString.RESPONSE_STRING_unsupportedCredential,
          );
          expect(
            getErrorResponseString('login_required'),
            ResponseString.RESPONSE_STRING_aloginIsRequired,
          );
          expect(
            getErrorResponseString('account_selection_required'),
            ResponseString.RESPONSE_STRING_aloginIsRequired,
          );

          expect(
            getErrorResponseString('consent_required'),
            ResponseString.RESPONSE_STRING_userConsentIsRequired,
          );

          expect(
            getErrorResponseString('registration_not_supported'),
            ResponseString.RESPONSE_STRING_theWalletIsNotRegistered,
          );

          expect(
            getErrorResponseString('invalid_grant'),
            ResponseString.RESPONSE_STRING_credentialIssuanceDenied,
          );
          expect(
            getErrorResponseString('invalid_client'),
            ResponseString.RESPONSE_STRING_credentialIssuanceDenied,
          );
          expect(
            getErrorResponseString('invalid_token'),
            ResponseString.RESPONSE_STRING_credentialIssuanceDenied,
          );

          expect(
            getErrorResponseString('unsupported_credential_format'),
            ResponseString.RESPONSE_STRING_thisCredentialFormatIsNotSupported,
          );

          expect(
            getErrorResponseString('unsupported_format'),
            ResponseString.RESPONSE_STRING_thisFormatIsNotSupported,
          );

          expect(
            getErrorResponseString('invalid_issuer_metadata'),
            ResponseString.RESPONSE_STRING_theCredentialOfferIsInvalid,
          );

          expect(
            getErrorResponseString('server_error'),
            ResponseString.RESPONSE_STRING_theServiceIsNotAvailable,
          );

          expect(
            getErrorResponseString('issuance_pending'),
            ResponseString.RESPONSE_STRING_theIssuanceOfThisCredentialIsPending,
          );

          expect(
            getErrorResponseString('random'),
            ResponseString.RESPONSE_STRING_thisRequestIsNotSupported,
          );
        });

        test('isIDTokenOnly', () {
          expect(isIDTokenOnly('id_token'), true);
          expect(isIDTokenOnly('id_token vp_token'), false);
          expect(isIDTokenOnly('vp_token'), false);
          expect(isIDTokenOnly(''), false);
        });

        test('isVPTokenOnly', () {
          expect(isVPTokenOnly('id_token'), false);
          expect(isVPTokenOnly('vp_token'), true);
          expect(isVPTokenOnly('id_token vp_token'), false);
          expect(isVPTokenOnly(''), false);
        });

        test('isIDTokenAndVPToken', () {
          expect(isIDTokenAndVPToken('id_token'), false);
          expect(isIDTokenAndVPToken('vp_token'), false);
          expect(isIDTokenAndVPToken('id_token vp_token'), true);
          expect(isIDTokenAndVPToken(''), false);
        });

        test('hasIDToken', () {
          expect(hasIDToken('id_token'), true);
          expect(hasIDToken('vp_token'), false);
          expect(hasIDToken('id_token vp_token'), true);
          expect(hasIDToken(''), false);
        });

        test('hasVPToken', () {
          expect(hasVPToken('id_token'), false);
          expect(hasVPToken('vp_token'), true);
          expect(hasVPToken('id_token vp_token'), true);
          expect(hasVPToken(''), false);
        });

        test('hasIDTokenOrVPToken returns correct url', () {
          expect(hasIDTokenOrVPToken('id_token'), true);
          expect(hasIDTokenOrVPToken('vp_token'), true);
          expect(hasIDTokenOrVPToken('id_token vp_token'), true);
          expect(hasIDTokenOrVPToken(''), false);
        });

        test('getUpdatedUrlForSIOPV2OIC4VP', () {
          final uri = Uri.parse('https://example.com');
          final response = {
            'response_type': 'code',
            'redirect_uri': 'https://example.com/callback',
            'scope': 'openid profile',
            'response_uri': 'https://example.com/response',
            'response_mode': 'form_post',
            'nonce': '12345',
            'client_id': 'client123',
            'claims': {
              'id_token': {
                'email': {'essential': true},
              },
            },
            'state': 'state123',
            'presentation_definition': {
              'id': 'cred-123',
              'format': 'vp',
              'input_descriptors': [],
            },
            'presentation_definition_uri': 'https://example.com/presentation',
            'registration': {
              'token_endpoint_auth_method': 'client_secret_basic',
            },
            'client_metadata': {'example_key': 'example_value'},
            'client_metadata_uri': 'https://example.com/client_metadata',
          };

          final updatedUrl =
              getUpdatedUrlForSIOPV2OIC4VP(uri: uri, response: response);

          expect(
            updatedUrl.split('&'),
            containsAll([
              'scope=openid+profile',
              'client_id=client123',
              'redirect_uri=https%3A%2F%2Fexample.com%2Fcallback',
              'response_uri=https%3A%2F%2Fexample.com%2Fresponse',
              'response_mode=form_post',
              'nonce=12345',
              'state=state123',
              'response_type=code',
              // ignore: lines_longer_than_80_chars
              'claims=%7B%27id_token%27%3A%7B%27email%27%3A%7B%27essential%27%3Atrue%7D%7D%7D',
              // ignore: lines_longer_than_80_chars
              'presentation_definition=%7B%27id%27%3A%27cred-123%27%2C%27format%27%3A%27vp%27%2C%27input_descriptors%27%3A%5B%5D%7D',
              // ignore: lines_longer_than_80_chars
              'presentation_definition_uri=https%3A%2F%2Fexample.com%2Fpresentation',
              // ignore: lines_longer_than_80_chars
              'registration=%7B%22token_endpoint_auth_method%22%3A%22client_secret_basic%22%7D',
              'client_metadata=%7B%22example_key%22%3A%22example_value%22%7D',
              'client_metadata_uri=https%3A%2F%2Fexample.com%2Fclient_metadata',
            ]),
          );
        });

        group('getPresentVCDetails', () {
          test(
              // ignore: lines_longer_than_80_chars
              'returns correct value when presentationDefinition ldp_vc formats',
              () {
            expect(
              getPresentVCDetails(
                vcFormatType: VCFormatType.ldpVc,
                presentationDefinition: PresentationDefinition(
                  inputDescriptors: [],
                  format: Format.fromJson(
                    {
                      'ldp_vc': {
                        'proof_type': <String>[],
                      },
                    },
                  ),
                ),
                clientMetaData: null,
              ),
              (true, false, false, false),
            );
          });

          test(
              // ignore: lines_longer_than_80_chars
              'throws ResponseMessage when presentationDefinition has no formats',
              () {
            final presentationDefinition = PresentationDefinition(
              inputDescriptors: [],
              format: Format.fromJson({}),
            );

            expect(
              () => getPresentVCDetails(
                vcFormatType: VCFormatType.ldpVc,
                presentationDefinition: presentationDefinition,
                clientMetaData: null,
              ),
              throwsA(
                isA<ResponseMessage>().having((e) => e.data, '', {
                  'error': 'invalid_request',
                  'error_description': 'VC format is missing',
                }),
              ),
            );
          });

          test(
              'returns correct value(VCFormatType.jwtVc) when'
              ' presentationDefinition.format'
              ' and clientMetaData are null', () {
            expect(
              getPresentVCDetails(
                vcFormatType: VCFormatType.jwtVc,
                presentationDefinition: PresentationDefinition(
                  inputDescriptors: [],
                  format: null,
                ),
                clientMetaData: null,
              ),
              (false, true, false, false),
            );
          });

          test(
              'returns correct value(VCFormatType.jwtVcJson) when'
              ' presentationDefinition.format'
              ' and clientMetaData are null', () {
            expect(
              getPresentVCDetails(
                vcFormatType: VCFormatType.jwtVcJson,
                presentationDefinition: PresentationDefinition(
                  inputDescriptors: [],
                  format: null,
                ),
                clientMetaData: null,
              ),
              (false, false, true, false),
            );
          });

          test(
              'returns correct value(VCFormatType.vcSdJWT) when'
              ' presentationDefinition.format'
              ' and clientMetaData are null', () {
            expect(
              getPresentVCDetails(
                vcFormatType: VCFormatType.vcSdJWT,
                presentationDefinition: PresentationDefinition(
                  inputDescriptors: [],
                  format: null,
                ),
                clientMetaData: null,
              ),
              (false, false, false, true),
            );
          });

          test(
              'returns correct value(VCFormatType.jwtVcJson) when'
              ' presentationDefinition.format is null'
              ' and clientMetaData is provided', () {
            expect(
              getPresentVCDetails(
                vcFormatType: VCFormatType.jwtVcJson,
                presentationDefinition: PresentationDefinition(
                  inputDescriptors: [],
                  format: null,
                ),
                clientMetaData: {
                  'vp_formats': {
                    'jwt_vc_json': 'here',
                  },
                },
              ),
              (false, false, true, false),
            );
          });

          test(
              'returns correct value(VCFormatType.vc+sd-jwt) when'
              ' presentationDefinition.format is null'
              ' and clientMetaData is provided', () {
            expect(
              getPresentVCDetails(
                vcFormatType: VCFormatType.vcSdJWT,
                presentationDefinition: PresentationDefinition(
                  inputDescriptors: [],
                  format: null,
                ),
                clientMetaData: {
                  'vp_formats': {
                    'vc+sd-jwt': 'here',
                  },
                },
              ),
              (false, false, false, true),
            );
          });
        });

        group('collectSdValues', () {
          test('returns an empty list when no _sd key is present', () {
            final data = {
              'a': 1,
              'b': {
                'c': 2,
              },
            };
            final result = collectSdValues(data);
            expect(result, isEmpty);
          });

          test('collects values from _sd keys', () {
            final data = {
              '_sd': [1, 2, 3],
              'a': {
                '_sd': [4, 5],
              },
              'b': {
                'c': {
                  '_sd': [6, 7],
                },
              },
            };
            final result = collectSdValues(data);
            expect(result, [1, 2, 3, 4, 5, 6, 7]);
          });

          test('collects values from ... keys within lists', () {
            final data = {
              'a': [
                {
                  '...': 1,
                },
                {
                  '...': 2,
                },
              ],
              'c': [
                {
                  '...': 3,
                },
              ],
            };
            final result = collectSdValues(data);
            expect(result, [1, 2, 3]);
          });

          test('handles complex nested structures', () {
            final data = {
              '_sd': [1],
              'a': {
                '_sd': [2],
                'b': [
                  {
                    '...': 3,
                  },
                ],
              },
              'd': [
                {
                  '...': 5,
                },
              ],
            };
            final result = collectSdValues(data);
            expect(result, [1, 2, 3, 5]);
          });

          test('does not collect non-_sd or non-... values', () {
            final data = {
              'a': 1,
              'b': {
                'c': 2,
                'd': [
                  {
                    'e': 3,
                  },
                ],
              },
            };
            final result = collectSdValues(data);
            expect(result, isEmpty);
          });
        });

        group('checkX509', () {
          test('throws error for x5c is null', () async {
            final result = await checkX509(
              clientId: '',
              header: {},
              encodedData: '',
            );
            expect(result, isNull);
          });

          test('throws error for invalid x5c format', () async {
            expect(
              () => checkX509(
                clientId: '',
                header: {
                  'x5c': 'i am not list',
                },
                encodedData: '',
              ),
              throwsA(
                isA<ResponseMessage>().having((e) => e.data, '', {
                  'error': 'invalid_format',
                  'error_description': 'x509_san_dns scheme error',
                }),
              ),
            );
          });

          test('throws error for invalid x5c is empty', () async {
            expect(
              () => checkX509(
                clientId: '',
                header: {
                  'x5c': <String>[],
                },
                encodedData: '',
              ),
              throwsA(
                isA<ResponseMessage>().having((e) => e.data, '', {
                  'error': 'invalid_format',
                  'error_description': 'x509_san_dns scheme error',
                }),
              ),
            );
          });
        });

        group('checkVerifierAttestation', () {
          final jwtDecode = JWTDecode();
          test('throws error if JWT is missing', () async {
            expect(
              () => checkVerifierAttestation(
                clientId: '',
                header: {},
                jwtDecode: jwtDecode,
              ),
              throwsA(
                isA<ResponseMessage>().having((e) => e.data, '', {
                  'error': 'invalid_format',
                  'error_description': 'verifier_attestation scheme error',
                }),
              ),
            );
          });

          test('throws error when sub is null', () async {
            expect(
              () => checkVerifierAttestation(
                clientId: '',
                header: {
                  'jwt':
                      // ignore: lines_longer_than_80_chars
                      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiSm9obiBEb2UiLCJpYXQiOjE1MTYyMzkwMjJ9.hqWGSaFpvbrXkOWc6lrnffhNWR19W_S1YKFBx2arWBk',
                },
                jwtDecode: jwtDecode,
              ),
              throwsA(
                isA<ResponseMessage>().having((e) => e.data, '', {
                  'error': 'invalid_format',
                  'error_description': 'verifier_attestation scheme error',
                }),
              ),
            );
          });

          test('throws error when sub is not equal to clientId', () async {
            expect(
              () => checkVerifierAttestation(
                clientId: 'random',
                header: {
                  'jwt':
                      // ignore: lines_longer_than_80_chars
                      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjQiLCJuYW1lIjoiSm9obiBEb2UiLCJpYXQiOjE1MTYyMzkwMjJ9.EyF5bWaxNMFda_CRAOHu3aagShvHlGpnSWK7uFsj23Q',
                },
                jwtDecode: jwtDecode,
              ),
              throwsA(
                isA<ResponseMessage>().having((e) => e.data, '', {
                  'error': 'invalid_format',
                  'error_description': 'verifier_attestation scheme error',
                }),
              ),
            );
          });

          test('throws error when sub cnf is null', () async {
            expect(
              () => checkVerifierAttestation(
                clientId: '124',
                header: {
                  'jwt':
                      // ignore: lines_longer_than_80_chars
                      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjQiLCJuYW1lIjoiSm9obiBEb2UiLCJpYXQiOjE1MTYyMzkwMjJ9.EyF5bWaxNMFda_CRAOHu3aagShvHlGpnSWK7uFsj23Q',
                },
                jwtDecode: jwtDecode,
              ),
              throwsA(
                isA<ResponseMessage>().having((e) => e.data, '', {
                  'error': 'invalid_format',
                  'error_description': 'verifier_attestation scheme error',
                }),
              ),
            );
          });

          test('throws error when cnf is not Map', () async {
            expect(
              () => checkVerifierAttestation(
                clientId: '124',
                header: {
                  'jwt':
                      // ignore: lines_longer_than_80_chars
                      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjQiLCJuYW1lIjoiSm9obiBEb2UiLCJpYXQiOjE1MTYyMzkwMjIsImNuZiI6IjEyMyJ9.xZYbK4Oe2jGyQwyOiK5Zv0sHDtfjgY-sdS7WKs-aZYQ',
                },
                jwtDecode: jwtDecode,
              ),
              throwsA(
                isA<ResponseMessage>().having((e) => e.data, '', {
                  'error': 'invalid_format',
                  'error_description': 'verifier_attestation scheme error',
                }),
              ),
            );
          });

          test('throws error when cnf does not contain jwk', () async {
            expect(
              () => checkVerifierAttestation(
                clientId: '124',
                header: {
                  'jwt':
                      // ignore: lines_longer_than_80_chars
                      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjQiLCJuYW1lIjoiSm9obiBEb2UiLCJpYXQiOjE1MTYyMzkwMjIsImNuZiI6eyJ0ZXN0IjoidGVzdCJ9fQ.tnYvd00vYuDxjTtC7goSB5EQUNGtSFR1JBpY1CTRzD0',
                },
                jwtDecode: jwtDecode,
              ),
              throwsA(
                isA<ResponseMessage>().having((e) => e.data, '', {
                  'error': 'invalid_format',
                  'error_description': 'verifier_attestation scheme error',
                }),
              ),
            );
          });

          test('throws error when jwk is not Map', () async {
            expect(
              () => checkVerifierAttestation(
                clientId: '124',
                header: {
                  'jwt':
                      // ignore: lines_longer_than_80_chars
                      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjQiLCJuYW1lIjoiSm9obiBEb2UiLCJpYXQiOjE1MTYyMzkwMjIsImNuZiI6eyJqd2siOiJ0ZXN0In19.qjqntbtQTnRcR60UvveWyv8t3Y1dFMI0DLSyB_pwqBk',
                },
                jwtDecode: jwtDecode,
              ),
              throwsA(
                isA<ResponseMessage>().having((e) => e.data, '', {
                  'error': 'invalid_format',
                  'error_description': 'verifier_attestation scheme error',
                }),
              ),
            );
          });

          test('return correct jwk', () async {
            final result = await checkVerifierAttestation(
              clientId: '124',
              header: {
                'jwt':
                    // ignore: lines_longer_than_80_chars
                    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjQiLCJuYW1lIjoiSm9obiBEb2UiLCJpYXQiOjE1MTYyMzkwMjIsImNuZiI6eyJqd2siOnsibmFtZSI6IkJpYmFzaCJ9fX0.daqYrO5JtoW9o0ZEDlG2a6ctAgQxaNxTT0iYyVBIIkY',
              },
              jwtDecode: jwtDecode,
            );

            expect(result, {'name': 'Bibash'});
          });
        });

        test('returns correct wallet Address', () {
          expect(
            getWalletAddress(
              TezosAssociatedAddressModel(
                id: 'id',
                type: 'type',
                issuedBy: const Author('name'),
                associatedAddress: 'tezosAddress',
              ),
            ),
            'tezosAddress',
          );
          expect(
            getWalletAddress(
              EthereumAssociatedAddressModel(
                id: 'id',
                type: 'type',
                issuedBy: const Author('name'),
                associatedAddress: 'ethereumAddress',
              ),
            ),
            'ethereumAddress',
          );
          expect(
            getWalletAddress(
              PolygonAssociatedAddressModel(
                id: 'id',
                type: 'type',
                issuedBy: const Author('name'),
                associatedAddress: 'polygonAddress',
              ),
            ),
            'polygonAddress',
          );
          expect(
            getWalletAddress(
              BinanceAssociatedAddressModel(
                id: 'id',
                type: 'type',
                issuedBy: const Author('name'),
                associatedAddress: 'address',
              ),
            ),
            'address',
          );
          expect(
            getWalletAddress(
              FantomAssociatedAddressModel(
                id: 'id',
                type: 'type',
                issuedBy: const Author('name'),
                associatedAddress: 'fantomAddress',
              ),
            ),
            'fantomAddress',
          );
          expect(
            getWalletAddress(
              AgeRangeModel(
                id: 'id',
                type: 'type',
                issuedBy: const Author('name'),
              ),
            ),
            isNull,
          );
        });

        group('fetchRpcUrl', () {
          late DotEnv mockDotenv;

          setUpAll(() {
            mockDotenv = MockDotenv();
          });

          test('returns rpcNodeUrl for BinanceNetwork.mainNet()', () async {
            final result = await fetchRpcUrl(
              blockchainNetwork: BinanceNetwork.mainNet(),
              dotEnv: mockDotenv,
            );
            expect(result, 'https://bsc-dataseed.binance.org/');
          });

          test('returns rpcNodeUrl for BinanceNetwork.testNet()', () async {
            final result = await fetchRpcUrl(
              blockchainNetwork: BinanceNetwork.testNet(),
              dotEnv: mockDotenv,
            );
            expect(result, 'https://bsc-testnet.public.blastapi.io');
          });

          test('returns rpcNodeUrl for  FantomNetwork.mainNet()', () async {
            final result = await fetchRpcUrl(
              blockchainNetwork: FantomNetwork.mainNet(),
              dotEnv: mockDotenv,
            );
            expect(result, 'https://rpcapi.fantom.network/');
          });

          test('returns rpcNodeUrl for  FantomNetwork.testNet()', () async {
            final result = await fetchRpcUrl(
              blockchainNetwork: FantomNetwork.testNet(),
              dotEnv: mockDotenv,
            );
            expect(result, 'https://rpc.testnet.fantom.network');
          });

          test('returns infura URL for PolygonNetwork.mainNet()', () async {
            when(() => mockDotenv.load()).thenAnswer((_) async => {});
            when(() => mockDotenv.get('INFURA_API_KEY')).thenReturn('123');
            final result = await fetchRpcUrl(
              blockchainNetwork: PolygonNetwork.mainNet(),
              dotEnv: mockDotenv,
            );
            expect(result, '${Parameters.POLYGON_INFURA_URL}123');
          });

          test('returns infura URL for PolygonNetwork on Testnet', () async {
            final result = await fetchRpcUrl(
              blockchainNetwork: PolygonNetwork.testNet(),
              dotEnv: mockDotenv,
            );
            expect(result, 'https://rpc-mumbai.maticvigil.com');
          });

          test('returns infura URL for EthereumNetwork.mainNet()', () async {
            when(() => mockDotenv.load()).thenAnswer((_) async => {});
            when(() => mockDotenv.get('INFURA_API_KEY')).thenReturn('123');
            final result = await fetchRpcUrl(
              blockchainNetwork: EthereumNetwork.mainNet(),
              dotEnv: mockDotenv,
            );
            expect(result, '${Parameters.web3RpcMainnetUrl}123');
          });

          test('returns infura URL for EthereumNetwork.testNet()', () async {
            final result = await fetchRpcUrl(
              blockchainNetwork: EthereumNetwork.testNet(),
              dotEnv: mockDotenv,
            );
            expect(result, 'https://rpc.sepolia.dev');
          });

          test('returns infura URL for TezosNetwork.mainNet()', () async {
            when(() => mockDotenv.load()).thenAnswer((_) async => {});
            when(() => mockDotenv.get('INFURA_API_KEY')).thenReturn('123');
            final result = await fetchRpcUrl(
              blockchainNetwork: TezosNetwork.mainNet(),
              dotEnv: mockDotenv,
            );
            expect(result, '${Parameters.web3RpcMainnetUrl}123');
          });

          test('returns infura URL for TezosNetwork.ghostnet()', () async {
            final result = await fetchRpcUrl(
              blockchainNetwork: TezosNetwork.ghostnet(),
              dotEnv: mockDotenv,
            );
            expect(result, 'https://rpc.tzkt.io/ghostnet');
          });
        });
      });
    });
  });
}
