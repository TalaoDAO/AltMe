import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:did_kit/did_kit.dart';
import 'package:key_generator/key_generator.dart';
import 'package:secure_storage/secure_storage.dart';

Future<void> generateAccount({
  required List<String> mnemonic,
  required SecureStorageProvider secureStorageProvider,
  required KeyGenerator keyGenerator,
  required DIDKitProvider didKitProvider,
  required HomeCubit homeCubit,
  required WalletCubit walletCubit,
  required SplashCubit splashCubit,
  required AltmeChatSupportCubit altmeChatSupportCubit,
  required ProfileCubit profileCubit,
}) async {
  final mnemonicFormatted = mnemonic.join(' ');

  /// ssi wallet
  await secureStorageProvider.set(
    SecureStorageKeys.ssiMnemonic,
    mnemonicFormatted,
  );

  /// did
  final ssiKey = await keyGenerator.jwkFromMnemonic(
    mnemonic: mnemonicFormatted,
    accountType: AccountType.ssi,
  );

  await secureStorageProvider.set(SecureStorageKeys.ssiKey, ssiKey);

  /// create profile
  await profileCubit.load();

  /// what's new popup disabled
  splashCubit.disableWhatsNewPopUp();

  /// crypto wallet
  await walletCubit.createCryptoWallet(
    mnemonicOrKey: mnemonicFormatted,
    isImported: false,
    isFromOnboarding: true,
  );

  if (profileCubit.state.model.profileType == ProfileType.enterprise) {
    /// initiate chat if it is enterprise
    await altmeChatSupportCubit.init();
  }

  await homeCubit.emitHasWallet();
}
