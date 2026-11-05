import 'dart:typed_data';
import 'dart:ui';

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/enum/type/language_type.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/lang/cubit/lang_state.dart';
import 'package:altme/oidc4vc/helper_function/add_oidc4vc_credential.dart';
import 'package:altme/oidc4vc/model/credential_acceptance_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform_p256_keys/platform_p256_keys.dart';

import '../support/issuer_signed_fixture.dart';

class _MockCredentialsCubit extends Mock implements CredentialsCubit {}

class _MockProfileCubit extends Mock implements ProfileCubit {}

class _MockLangCubit extends Mock implements LangCubit {}

class _MockProfileModel extends Mock implements ProfileModel {}

class _MockPlatformP256Keys extends Mock implements PlatformP256Keys {}

class _FakeProfileState extends Fake implements ProfileState {
  _FakeProfileState(this.model);

  @override
  final ProfileModel model;
}

/// The SEC1 point of a test key whose coordinates are all [byte].
Uint8List _point(int byte) => Uint8List.fromList([
  0x04,
  ...List.filled(32, byte),
  ...List.filled(32, byte + 1),
]);

void main() {
  group('buildCredentialAcceptanceItem with platform keys', () {
    late _MockCredentialsCubit credentialsCubit;
    late _MockPlatformP256Keys keys;
    const points = {'mdoc_a': 3, 'mdoc_b': 5, 'mdoc_c': 7};

    setUp(() {
      final profileModel = _MockProfileModel();
      when(() => profileModel.profileType).thenReturn(ProfileType.custom);
      final langCubit = _MockLangCubit();
      when(() => langCubit.state).thenReturn(
        const LangState(locale: Locale('en'), languageType: LanguageType.en),
      );
      final profileCubit = _MockProfileCubit();
      when(
        () => profileCubit.state,
      ).thenReturn(_FakeProfileState(profileModel));
      when(() => profileCubit.langCubit).thenReturn(langCubit);
      credentialsCubit = _MockCredentialsCubit();
      when(() => credentialsCubit.profileCubit).thenReturn(profileCubit);

      keys = _MockPlatformP256Keys();
      for (final MapEntry(key: alias, value: byte) in points.entries) {
        when(() => keys.find(alias)).thenAnswer(
          (_) async => PlatformP256Key(
            alias: alias,
            publicKey: _point(byte),
            hardwareBacked: true,
          ),
        );
      }
      when(() => keys.delete(any())).thenAnswer((_) async {});
    });

    Map<String, dynamic> response(List<int> devicePoints) => {
      'credentials': [
        for (final byte in devicePoints)
          {'credential': testIssuerSigned(devicePoint: _point(byte))},
      ],
    };

    Future<CredentialAcceptanceItem> build(
      Map<String, dynamic> encoded,
      List<String> keyIds,
    ) => buildCredentialAcceptanceItem(
      encodedCredentialFromOIDC4VC: encoded,
      credentialsCubit: credentialsCubit,
      credentialType: 'mDL',
      format: 'mso_mdoc',
      openIdConfiguration: null,
      jwtDecode: JWTDecode(),
      keyIds: keyIds,
      platformKeys: keys,
    );

    test('stores every copy with the key it is bound to, whatever the order '
        'of the response', () async {
      // The conformance suite returns the credentials in reverse order of
      // the proofs.
      final item = await build(response([7, 5, 3]), [
        'mdoc_a',
        'mdoc_b',
        'mdoc_c',
      ]);

      final models = item.credentialModels;
      expect(models.map((m) => m.keyId), ['mdoc_c', 'mdoc_b', 'mdoc_a']);
      expect(models.map((m) => m.id).toSet(), hasLength(3));
      final batchId = models.first.batchId;
      expect(batchId, isNotNull);
      expect(models.map((m) => m.batchId), everyElement(batchId));
      verifyNever(() => keys.delete(any()));
    });

    test('deletes the keys no credential is bound to', () async {
      final item = await build(response([3, 5]), [
        'mdoc_a',
        'mdoc_b',
        'mdoc_c',
      ]);

      expect(item.credentialModels, hasLength(2));
      verify(() => keys.delete('mdoc_c')).called(1);
      verifyNever(() => keys.delete('mdoc_a'));
      verifyNever(() => keys.delete('mdoc_b'));
    });

    test('a single copy is not a batch', () async {
      final item = await build(response([3]), ['mdoc_a']);

      expect(item.batchCopies, isEmpty);
      expect(item.credentialModel.keyId, 'mdoc_a');
      expect(item.credentialModel.batchId, isNull);
    });

    test('rejects a response bound to none of the keys, and deletes them', () {
      expect(
        () => build(response([9]), ['mdoc_a', 'mdoc_b']),
        throwsA(isA<ResponseMessage>()),
      );
    });

    test('a key the response is not bound to is deleted even when it is '
        'rejected', () async {
      await expectLater(
        build(response([9]), ['mdoc_a']),
        throwsA(isA<ResponseMessage>()),
      );

      verify(() => keys.delete('mdoc_a')).called(1);
    });
  });
}
