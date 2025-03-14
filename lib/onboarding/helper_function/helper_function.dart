import 'package:altme/activity_log/activity_log.dart';
import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/key_generator/key_generator.dart';
import 'package:altme/matrix_notification/matrix_notification.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:did_kit/did_kit.dart';

Future<void> generateAccount({
  required List<String> mnemonic,
  required KeyGenerator keyGenerator,
  required DIDKitProvider didKitProvider,
  required HomeCubit homeCubit,
  required SplashCubit splashCubit,
  required AltmeChatSupportCubit altmeChatSupportCubit,
  required MatrixNotificationCubit matrixNotificationCubit,
  required ActivityLogManager activityLogManager,
  required QRCodeScanCubit qrCodeScanCubit,
  required WalletCubit walletCubit,
  required CredentialsCubit credentialsCubit,
  required ProfileCubit profileCubit,
  required WalletConnectCubit walletConnectCubit,
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

  await activityLogManager.saveLog(LogData(type: LogType.walletInit));

  /// create profile
  await profileCubit.load();

  /// crypto wallet
  await walletCubit.createCryptoWallet(
    qrCodeScanCubit: qrCodeScanCubit,
    credentialsCubit: credentialsCubit,
    walletConnectCubit: walletConnectCubit,
    mnemonicOrKey: mnemonicFormatted,
    isImported: false,
    isFromOnboarding: true,
  );

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

  await homeCubit.emitHasWallet();
}
