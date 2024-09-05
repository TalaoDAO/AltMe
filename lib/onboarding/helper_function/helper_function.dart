import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/matrix_notification/matrix_notification.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:did_kit/did_kit.dart';
import 'package:key_generator/key_generator.dart';

Future<void> generateAccount({
  required List<String> mnemonic,
  required KeyGenerator keyGenerator,
  required DIDKitProvider didKitProvider,
  required HomeCubit homeCubit,
  required WalletCubit walletCubit,
  required SplashCubit splashCubit,
  required AltmeChatSupportCubit altmeChatSupportCubit,
  required MatrixNotificationCubit matrixNotificationCubit,
  required ProfileCubit profileCubit,
}) async {
  final mnemonicFormatted = mnemonic.join(' ');

  /// ssi wallet
  await profileCubit.secureStorageProvider.set(
    SecureStorageKeys.ssiMnemonic,
    mnemonicFormatted,
  );

  /// did
  final ssiKey = await keyGenerator.jwkFromMnemonic(
    mnemonic: mnemonicFormatted,
    accountType: AccountType.ssi,
  );

  await profileCubit.secureStorageProvider
      .set(SecureStorageKeys.ssiKey, ssiKey);

  /// create profile
  await profileCubit.load();

  /// crypto wallet
  await walletCubit.createCryptoWallet(
    mnemonicOrKey: mnemonicFormatted,
    isImported: false,
    isFromOnboarding: true,
  );

  if (profileCubit.state.model.walletType == WalletType.enterprise) {
    final helpCenterOptions =
        profileCubit.state.model.profileSetting.helpCenterOptions;

    if (helpCenterOptions.customChatSupport &&
        helpCenterOptions.customChatSupportName != null) {
      await altmeChatSupportCubit.init();
    }

    if (helpCenterOptions.customNotification != null &&
        helpCenterOptions.customNotification! &&
        helpCenterOptions.customNotificationRoom != null) {
      await matrixNotificationCubit.init();
    }
  }

  await homeCubit.emitHasWallet();
}
