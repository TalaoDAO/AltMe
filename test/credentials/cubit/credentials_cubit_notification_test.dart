import 'package:altme/activity_log/activity_log.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/key_generator/key_generator.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:did_kit/did_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oidc4vc/oidc4vc.dart';
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

class _FakeLogData extends Fake implements LogData {}

void main() {
  const notification = IssuanceNotification(
    endpoint: 'https://issuer.example.com/notification',
    notificationId: 'n-1',
    accessToken: 'access-token',
  );

  late _MockOidc4vci oidc4vc;
  late _MockCredentialsRepository repository;
  late CredentialsCubit cubit;

  setUpAll(() {
    registerFallbackValue(notification);
    registerFallbackValue(IssuanceNotificationEvent.credentialAccepted);
    registerFallbackValue(Dio());
    registerFallbackValue(_FakeLogData());
    registerFallbackValue(TEST_CREDENTIAL);
  });

  setUp(() {
    oidc4vc = _MockOidc4vci();
    repository = _MockCredentialsRepository();
    final profileCubit = _MockProfileCubit();
    final advanceSettingsCubit = _MockAdvanceSettingsCubit();
    final activityLogManager = _MockActivityLogManager();

    when(
      () => oidc4vc.sendNotification(
        notification: any(named: 'notification'),
        event: any(named: 'event'),
        dio: any(named: 'dio'),
      ),
    ).thenAnswer((_) async {});
    when(() => repository.insert(any())).thenAnswer((_) async => 1);
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
      oidc4vc: oidc4vc,
      walletCubit: _MockWalletCubit(),
      activityLogManager: activityLogManager,
    );
  });

  Future<void> insert(CredentialModel credential) => cubit.insertCredential(
    credential: credential,
    uri: Uri.parse('https://issuer.example.com'),
    isPendingCredential: true,
  );

  void verifySent(IssuanceNotificationEvent event, {int times = 1}) => verify(
    () => oidc4vc.sendNotification(
      notification: notification,
      event: event,
      dio: any(named: 'dio'),
    ),
  ).called(times);

  group('CredentialsCubit issuance notifications', () {
    test('sends credential_accepted once the credential is stored', () async {
      cubit.expectIssuanceNotification(
        credentialId: TEST_CREDENTIAL.id,
        notification: notification,
      );

      await insert(TEST_CREDENTIAL);
      await insert(TEST_CREDENTIAL);

      verifySent(IssuanceNotificationEvent.credentialAccepted);
    });

    test('sends credential_failure when storing fails', () async {
      when(() => repository.insert(any())).thenThrow(Exception('disk full'));
      cubit.expectIssuanceNotification(
        credentialId: TEST_CREDENTIAL.id,
        notification: notification,
      );

      await expectLater(insert(TEST_CREDENTIAL), throwsException);

      verifySent(IssuanceNotificationEvent.credentialFailure);
    });

    test('reports the credentials of one response once', () async {
      final sibling = TEST_CREDENTIAL.copyWith(id: 'sibling');
      cubit
        ..expectIssuanceNotification(
          credentialId: TEST_CREDENTIAL.id,
          notification: notification,
        )
        ..expectIssuanceNotification(
          credentialId: sibling.id,
          notification: notification,
        );

      await insert(TEST_CREDENTIAL);
      await insert(sibling);

      verifySent(IssuanceNotificationEvent.credentialAccepted);
    });

    test('sends credential_deleted for what the user declined', () async {
      const other = IssuanceNotification(
        endpoint: 'https://issuer.example.com/notification',
        notificationId: 'n-2',
        accessToken: 'access-token',
      );
      cubit
        ..expectIssuanceNotification(
          credentialId: TEST_CREDENTIAL.id,
          notification: notification,
        )
        ..expectIssuanceNotification(
          credentialId: 'declined',
          notification: other,
        );

      await insert(TEST_CREDENTIAL);
      cubit
        ..notifyDeclinedCredentials()
        ..notifyDeclinedCredentials();

      verifySent(IssuanceNotificationEvent.credentialAccepted);
      verify(
        () => oidc4vc.sendNotification(
          notification: other,
          event: IssuanceNotificationEvent.credentialDeleted,
          dio: any(named: 'dio'),
        ),
      ).called(1);
      verifyNoMoreInteractions(oidc4vc);
    });

    test('sends nothing for a credential with no notification', () async {
      await insert(TEST_CREDENTIAL);

      verifyNever(
        () => oidc4vc.sendNotification(
          notification: any(named: 'notification'),
          event: any(named: 'event'),
          dio: any(named: 'dio'),
        ),
      );
    });
  });
}
