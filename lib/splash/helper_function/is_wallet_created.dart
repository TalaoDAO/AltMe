import 'dart:convert';

import 'package:altme/app/logger/logger.dart';
import 'package:altme/app/shared/constants/constants.dart';
import 'package:altme/app/shared/enum/enum.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:secure_storage/secure_storage.dart';

Future<bool> isWalletCreated({
  required SecureStorageProvider secureStorageProvider,
  required QRCodeScanCubit qrCodeScanCubit,
  required CredentialsCubit credentialsCubit,
  required WalletCubit walletCubit,
  required WalletConnectCubit walletConnectCubit,
}) async {
  final log = getLogger('IsWalletCreated');

  log.i('did initialisation');
  final String? ssiMnemonic = await secureStorageProvider.get(
    SecureStorageKeys.ssiMnemonic,
  );
  if (ssiMnemonic == null || ssiMnemonic.isEmpty) {
    return false;
  }

  final String? ssiKey = await secureStorageProvider.get(
    SecureStorageKeys.ssiKey,
  );
  if (ssiKey == null || ssiKey.isEmpty) {
    return false;
  }

  log.i('blockchain initialisation');
  await blockchainInitialize(
    qrCodeScanCubit: qrCodeScanCubit,
    ssiMnemonic: ssiMnemonic,
    secureStorageProvider: secureStorageProvider,
    walletCubit: walletCubit,
    credentialsCubit: credentialsCubit,
    walletConnectCubit: walletConnectCubit,
  );

  log.i('wallet initialisation');
  await credentialsCubit.loadAllCredentials();

  return true;
}

Future<void> blockchainInitialize({
  required QRCodeScanCubit qrCodeScanCubit,
  required CredentialsCubit credentialsCubit,
  required WalletCubit walletCubit,
  required WalletConnectCubit walletConnectCubit,
  required String ssiMnemonic,
  required SecureStorageProvider secureStorageProvider,
}) async {
  // TODO(bibash): currentCryptoIndex => currentTezosIndex & currentEthIndex
  final String? currentCryptoIndex = await secureStorageProvider.get(
    SecureStorageKeys.currentCryptoIndex,
  );

  if (currentCryptoIndex != null && currentCryptoIndex.isNotEmpty) {
    /// load active index
    final activeIndex = int.parse(currentCryptoIndex);
    await walletCubit.setCurrentWalletAccount(activeIndex);

    final String? savedCryptoAccount = await secureStorageProvider.get(
      SecureStorageKeys.cryptoAccount,
    );

    if (savedCryptoAccount != null && savedCryptoAccount.isNotEmpty) {
      //load all the content of walletAddress
      final cryptoAccountJson =
          jsonDecode(savedCryptoAccount) as Map<String, dynamic>;
      final CryptoAccount cryptoAccount = CryptoAccount.fromJson(
        cryptoAccountJson,
      );
      walletCubit.emitCryptoAccount(cryptoAccount);
    } else {
      await walletCubit.setCurrentWalletAccount(0);
    }
  } else {
    await walletCubit.createCryptoWallet(
      mnemonicOrKey: ssiMnemonic,
      isImported: false,
      blockchainType: BlockchainType.tezos,
      isFromOnboarding: true,
      qrCodeScanCubit: qrCodeScanCubit,
      credentialsCubit: credentialsCubit,
      walletConnectCubit: walletConnectCubit,
    );
  }
}
