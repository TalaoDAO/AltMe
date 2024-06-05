import 'package:altme/app/app.dart';
import 'package:altme/chat_room/chat_room.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/lang/cubit/lang_state.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:key_generator/key_generator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oidc4vc/oidc4vc.dart';

import 'package:secure_storage/secure_storage.dart';

class MockDIDKitProvider extends Mock implements DIDKitProvider {}

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

class MockWalletCubit extends MockCubit<WalletState> implements WalletCubit {
  @override
  final state = WalletState(
    cryptoAccount: CryptoAccount(
      data: [
        CryptoAccountData(
          name: '',
          secretKey: '',
          blockchainType: BlockchainType.tezos,
          walletAddress: '',
        ),
      ],
    ),
  );

  @override
  Future<void> createCryptoWallet({
    String? accountName,
    required String mnemonicOrKey,
    required bool isImported,
    required bool isFromOnboarding,
    BlockchainType? blockchainType,
    bool showStatus = true,
    void Function({
      required CryptoAccount cryptoAccount,
      required MessageHandler messageHandler,
    })? onComplete,
  }) async {}
}

class MockSplashCubit extends MockCubit<SplashState> implements SplashCubit {}

class MockAltmeChatSupportCubit extends MockCubit<ChatRoomState>
    implements AltmeChatSupportCubit {}

class MockSecureStorageProvider extends Mock implements SecureStorageProvider {}

class MockLangCubit extends MockCubit<LangState> implements LangCubit {}

class MockOIDC4VC extends Mock implements OIDC4VC {}

void main() {
  group('generateAccount', () {
    late KeyGenerator keyGenerator;
    late MockDIDKitProvider didKitProvider;
    late MockHomeCubit homeCubit;
    late MockWalletCubit walletCubit;
    late MockSplashCubit splashCubit;
    late MockAltmeChatSupportCubit altmeChatSupportCubit;
    late ProfileCubit profileCubit;
    late MockSecureStorageProvider secureStorageProvider;

    setUp(() {
      keyGenerator = KeyGenerator();
      didKitProvider = MockDIDKitProvider();
      homeCubit = MockHomeCubit();
      walletCubit = MockWalletCubit();
      splashCubit = MockSplashCubit();
      altmeChatSupportCubit = MockAltmeChatSupportCubit();
      secureStorageProvider = MockSecureStorageProvider();

      when(() => secureStorageProvider.get(any())).thenAnswer((_) async => '');

      when(() => secureStorageProvider.set(any(), any()))
          .thenAnswer((_) async => Future<void>.value());

      profileCubit = ProfileCubit(
        didKitProvider: didKitProvider,
        jwtDecode: JWTDecode(),
        oidc4vc: MockOIDC4VC(),
        secureStorageProvider: secureStorageProvider,
        langCubit: MockLangCubit(),
      );
    });

    const mnemonicString = 'notice photo opera keen climb'
        ' agent soft parrot best joke field devote';

    test('should generate account correctly', () async {
      when(() => homeCubit.emitHasWallet()).thenAnswer((_) async => {});
      await generateAccount(
        mnemonic: mnemonicString.split(' '),
        keyGenerator: keyGenerator,
        didKitProvider: didKitProvider,
        homeCubit: homeCubit,
        walletCubit: walletCubit,
        splashCubit: splashCubit,
        altmeChatSupportCubit: altmeChatSupportCubit,
        profileCubit: profileCubit,
      );

      verify(
        () => secureStorageProvider.set(
          SecureStorageKeys.ssiMnemonic,
          mnemonicString,
        ),
      ).called(1);

      verify(() => homeCubit.emitHasWallet()).called(1);
    });

    test('should initiate chat if enterprise wallet', () async {
      when(() => homeCubit.emitHasWallet()).thenAnswer((_) async => {});
      when(() => altmeChatSupportCubit.init()).thenAnswer((_) async => {});

      await profileCubit.update(
        ProfileModel(
          polygonIdNetwork: PolygonIdNetwork.PolygonMainnet,
          walletType: WalletType.enterprise,
          walletProtectionType: WalletProtectionType.pinCode,
          isDeveloperMode: false,
          profileType: ProfileType.custom,
          profileSetting: ProfileSetting.initial(),
        ),
      );

      await generateAccount(
        mnemonic: mnemonicString.split(' '),
        keyGenerator: keyGenerator,
        didKitProvider: didKitProvider,
        homeCubit: homeCubit,
        walletCubit: walletCubit,
        splashCubit: splashCubit,
        altmeChatSupportCubit: altmeChatSupportCubit,
        profileCubit: profileCubit,
      );

      expect(profileCubit.state.model.walletType, WalletType.enterprise);
      verify(() => altmeChatSupportCubit.init()).called(1);
    });
  });
}
