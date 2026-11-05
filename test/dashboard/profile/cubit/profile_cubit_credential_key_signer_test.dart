import 'dart:typed_data';

import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/lang/cubit/lang_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:platform_p256_keys/platform_p256_keys.dart';
import 'package:secure_storage/secure_storage.dart';

class _MockSecureStorageProvider extends Mock
    implements SecureStorageProvider {}

class _MockDIDKitProvider extends Mock implements DIDKitProvider {}

class _MockOIDC4VC extends Mock implements OIDC4VCIClient {}

class _MockLangCubit extends MockCubit<LangState> implements LangCubit {}

class _MockPlatformP256Keys extends Mock implements PlatformP256Keys {}

void main() {
  late _MockSecureStorageProvider secureStorage;
  late _MockPlatformP256Keys platformKeys;

  setUpAll(() => registerFallbackValue(Uint8List(0)));

  setUp(() {
    secureStorage = _MockSecureStorageProvider();
    when(() => secureStorage.get(any())).thenAnswer((_) async => null);
    when(() => secureStorage.set(any(), any())).thenAnswer((_) async {});
    platformKeys = _MockPlatformP256Keys();
    when(
      () => platformKeys.signDigest(any(), any()),
    ).thenAnswer((_) async => Uint8List(64));
  });

  ProfileCubit build({JwtSigner Function(String keyId)? credentialKeySigner}) =>
      ProfileCubit(
        secureStorageProvider: secureStorage,
        oidc4vc: _MockOIDC4VC(),
        didKitProvider: _MockDIDKitProvider(),
        langCubit: _MockLangCubit(),
        jwtDecode: JWTDecode(),
        credentialKeySigner: credentialKeySigner,
        platformKeys: platformKeys,
      );

  group('ProfileCubit.signerForCredentialKey', () {
    test('signs with the platform key of a batch copy', () async {
      final cubit = build();

      final jws = await cubit.signerForCredentialKey('sdjwt_1')!(
        {'alg': 'ES256', 'typ': 'kb+jwt'},
        {'nonce': 'n'},
      );

      expect(jws.split('.'), hasLength(3));
      verify(() => platformKeys.signDigest('sdjwt_1', any())).called(1);
      await cubit.close();
    });

    test('signs with the platform key of an mso_mdoc', () async {
      final cubit = build();

      await cubit.signerForCredentialKey('mdoc_1')!({'alg': 'ES256'}, {});

      verify(() => platformKeys.signDigest('mdoc_1', any())).called(1);
      await cubit.close();
    });

    test('leaves any other key to the credential key signer', () async {
      final asked = <String>[];
      final cubit = build(
        credentialKeySigner: (keyId) {
          asked.add(keyId);
          return (header, payload) async => 'signed.by.wka';
        },
      );

      final jws = await cubit.signerForCredentialKey('wka-key-1')!({}, {});

      expect(jws, 'signed.by.wka');
      expect(asked, ['wka-key-1']);
      verifyNever(() => platformKeys.signDigest(any(), any()));
      await cubit.close();
    });

    test('has no signer for another key without a credential key signer', () {
      final cubit = build();

      expect(cubit.signerForCredentialKey('wka-key-1'), isNull);
      addTearDown(cubit.close);
    });
  });
}
