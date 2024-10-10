import 'package:altme/activity_log/activity_log.dart';
import 'package:altme/app/shared/shared.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/profile/profile.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mockito/mockito.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

class MockDioClient extends Mock implements DioClient {}

class MockCredentialsCubit extends Mock implements CredentialsCubit {}

class MockDIDKitProvider extends Mock implements DIDKitProvider {}

class MockSecureStorageProvider extends Mock implements SecureStorageProvider {}

class MockProfileCubit extends Mock implements ProfileCubit {}

class MockWalletCubit extends Mock implements WalletCubit {}

class MockOIDC4VC extends Mock implements OIDC4VC {}

class MockJWTDecode extends Mock implements JWTDecode {}

class MockActivityLogManager extends Mock implements ActivityLogManager {}

void main() {
  group('ScanCubit', () {
    late MockDioClient mockDioClient;
    late MockCredentialsCubit mockCredentialsCubit;
    late MockDIDKitProvider mockDIDKitProvider;
    late MockSecureStorageProvider mockSecureStorageProvider;
    late MockProfileCubit mockProfileCubit;
    late MockWalletCubit mockWalletCubit;
    late MockOIDC4VC mockOIDC4VC;
    late MockJWTDecode mockJWTDecode;
    late ScanCubit scanCubit;
    late ActivityLogManager activityLogManager;

    setUp(() {
      mockDioClient = MockDioClient();
      mockCredentialsCubit = MockCredentialsCubit();
      mockDIDKitProvider = MockDIDKitProvider();
      mockSecureStorageProvider = MockSecureStorageProvider();
      mockProfileCubit = MockProfileCubit();
      mockWalletCubit = MockWalletCubit();
      mockOIDC4VC = MockOIDC4VC();
      mockJWTDecode = MockJWTDecode();
      activityLogManager = MockActivityLogManager();

      scanCubit = ScanCubit(
        client: mockDioClient,
        credentialsCubit: mockCredentialsCubit,
        didKitProvider: mockDIDKitProvider,
        secureStorageProvider: mockSecureStorageProvider,
        profileCubit: mockProfileCubit,
        walletCubit: mockWalletCubit,
        oidc4vc: mockOIDC4VC,
        jwtDecode: mockJWTDecode,
        activityLogManager: activityLogManager,
      );
    });

    test('initial state is ScanState', () {
      expect(scanCubit.state, equals(const ScanState()));
    });

    // Add more tests here...
  });
}
