import 'package:altme/activity_log/activity_log.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/key_generator/key_generator.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:platform_p256_keys/platform_p256_keys.dart';
import 'package:secure_storage/secure_storage.dart';

import '../../test_objects.dart';

class _MockOidc4vci extends Mock implements OIDC4VCIClient {}

class _MockCredentialsRepository extends Mock
    implements CredentialsRepository {}

class _MockProfileCubit extends Mock implements ProfileCubit {}

class _MockAdvanceSettingsCubit extends Mock implements AdvanceSettingsCubit {}

class _MockActivityLogManager extends Mock implements ActivityLogManager {}

class _MockSecureStorageProvider extends Mock
    implements SecureStorageProvider {}

class _MockKeyGenerator extends Mock implements KeyGenerator {}

class _MockWalletCubit extends Mock implements WalletCubit {}

class _MockPlatformP256Keys extends Mock implements PlatformP256Keys {}

class _FakeLogData extends Fake implements LogData {}

void main() {
  late _MockCredentialsRepository repository;
  late _MockPlatformP256Keys platformKeys;
  late _MockActivityLogManager activityLogManager;
  late CredentialsCubit cubit;

  setUpAll(() {
    registerFallbackValue(_FakeLogData());
    registerFallbackValue(TEST_CREDENTIAL);
  });

  setUp(() {
    repository = _MockCredentialsRepository();
    platformKeys = _MockPlatformP256Keys();
    final profileCubit = _MockProfileCubit();
    final advanceSettingsCubit = _MockAdvanceSettingsCubit();
    activityLogManager = _MockActivityLogManager();

    when(() => repository.insert(any())).thenAnswer((_) async => 1);
    when(() => repository.deleteById(any())).thenAnswer((_) async => true);
    when(() => platformKeys.delete(any())).thenAnswer((_) async {});
    when(
      () => profileCubit.state,
    ).thenReturn(ProfileState(model: ProfileModel.empty()));
    when(() => advanceSettingsCubit.state).thenReturn(
      const AdvanceSettingsState(
        isGamingEnabled: true,
        isIdentityEnabled: true,
        isProfessionalEnabled: true,
        isBlockchainAccountsEnabled: true,
        isEducationEnabled: true,
        isPassEnabled: true,
        isSocialMediaEnabled: true,
        isCommunityEnabled: true,
        isOtherEnabled: true,
        isFinanceEnabled: true,
        isHumanityProofEnabled: true,
        isWalletIntegrityEnabled: true,
      ),
    );
    when(() => activityLogManager.saveLog(any())).thenAnswer((_) async {});

    cubit = CredentialsCubit(
      credentialsRepository: repository,
      secureStorageProvider: _MockSecureStorageProvider(),
      didKitProvider: DIDKitProvider(),
      advanceSettingsCubit: advanceSettingsCubit,
      keyGenerator: _MockKeyGenerator(),
      jwtDecode: JWTDecode(),
      profileCubit: profileCubit,
      oidc4vc: _MockOidc4vci(),
      walletCubit: _MockWalletCubit(),
      activityLogManager: activityLogManager,
      platformKeys: platformKeys,
    );
  });

  tearDown(() => cubit.close());

  CredentialModel credential(String id, {String? keyId, String? batchId}) =>
      TEST_CREDENTIAL.copyWith(id: id, keyId: keyId, batchId: batchId);

  Future<void> insert(CredentialModel credential) => cubit.insertCredential(
    credential: credential,
    uri: Uri.parse('https://issuer.example.com'),
    isPendingCredential: true,
    showMessage: false,
  );

  group('deleteById', () {
    test('deletes the platform key the credential is bound to', () async {
      await insert(credential('c1', keyId: 'sdjwt_1'));

      await cubit.deleteById(id: 'c1', showMessage: false);

      verify(() => platformKeys.delete('sdjwt_1')).called(1);
      expect(cubit.state.credentials, isEmpty);
    });

    test('leaves a Wallet Key Attestation key to its key store', () async {
      await insert(credential('c1', keyId: 'wka-key-1'));

      await cubit.deleteById(id: 'c1', showMessage: false);

      verifyNever(() => platformKeys.delete(any()));
    });
  });

  group('deleteWithCopies', () {
    test('deletes every copy of the batch and their keys', () async {
      await insert(credential('a1', keyId: 'sdjwt_a1', batchId: 'batch-a'));
      await insert(credential('alone'));
      await insert(credential('a2', keyId: 'sdjwt_a2', batchId: 'batch-a'));

      await cubit.deleteWithCopies(id: 'a2', showMessage: false);

      expect(cubit.state.credentials.map((c) => c.id), ['alone']);
      verify(() => repository.deleteById('a1')).called(1);
      verify(() => repository.deleteById('a2')).called(1);
      verify(() => platformKeys.delete('sdjwt_a1')).called(1);
      verify(() => platformKeys.delete('sdjwt_a2')).called(1);
    });

    test('deletes only the credential when it was issued alone', () async {
      await insert(credential('alone'));
      await insert(credential('other'));

      await cubit.deleteWithCopies(id: 'alone', showMessage: false);

      expect(cubit.state.credentials.map((c) => c.id), ['other']);
    });
  });

  group('deleteConsumedCopies', () {
    test(
      'deletes the presented copy and its key, and keeps the others',
      () async {
        await insert(credential('a1', keyId: 'sdjwt_a1', batchId: 'batch-a'));
        await insert(credential('a2', keyId: 'sdjwt_a2', batchId: 'batch-a'));

        await cubit.deleteConsumedCopies(['a1']);

        expect(cubit.state.credentials.map((c) => c.id), ['a2']);
        verify(() => platformKeys.delete('sdjwt_a1')).called(1);
        verifyNever(() => platformKeys.delete('sdjwt_a2'));
      },
    );

    test('keeps a credential issued alone, and its key', () async {
      await insert(credential('alone', keyId: 'sdjwt_alone'));

      await cubit.deleteConsumedCopies(['alone']);

      expect(cubit.state.credentials.map((c) => c.id), ['alone']);
      verifyNever(() => platformKeys.delete(any()));
    });

    test('deletes the last copy, so the card goes', () async {
      await insert(credential('a1', keyId: 'sdjwt_a1', batchId: 'batch-a'));

      await cubit.deleteConsumedCopies(['a1']);

      expect(cubit.state.credentials, isEmpty);
    });

    test('ignores an id it does not hold and a repeated id', () async {
      await insert(credential('a1', keyId: 'sdjwt_a1', batchId: 'batch-a'));

      await cubit.deleteConsumedCopies(['gone', 'a1', 'a1']);

      verify(() => repository.deleteById('a1')).called(1);
      verifyNever(() => repository.deleteById('gone'));
    });

    test('writes no activity log entry for a consumed copy', () async {
      await insert(credential('a1', keyId: 'sdjwt_a1', batchId: 'batch-a'));
      clearInteractions(activityLogManager);

      await cubit.deleteConsumedCopies(['a1']);

      verifyNever(() => activityLogManager.saveLog(any()));
    });
  });

  group('offered credential keys', () {
    test('deletes the keys of the copies that were not stored', () async {
      cubit
        ..expectCredentialKey(credentialId: 'a1', keyId: 'sdjwt_a1')
        ..expectCredentialKey(credentialId: 'a2', keyId: 'sdjwt_a2');
      await insert(credential('a1', keyId: 'sdjwt_a1', batchId: 'batch-a'));

      cubit.notifyDeclinedCredentials();
      await pumpEventQueue();

      verify(() => platformKeys.delete('sdjwt_a2')).called(1);
      verifyNever(() => platformKeys.delete('sdjwt_a1'));
    });

    test('deletes each declined key once', () async {
      cubit.expectCredentialKey(credentialId: 'a1', keyId: 'sdjwt_a1');

      cubit
        ..notifyDeclinedCredentials()
        ..notifyDeclinedCredentials();
      await pumpEventQueue();

      verify(() => platformKeys.delete('sdjwt_a1')).called(1);
    });
  });
}
