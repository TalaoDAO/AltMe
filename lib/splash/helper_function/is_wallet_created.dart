import 'dart:convert';

import 'package:altme/app/shared/constants/constants.dart';
import 'package:altme/did/did.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:secure_storage/secure_storage.dart';

Future<bool> isWalletCreated({
  required SecureStorageProvider secureStorageProvider,
  required DIDCubit didCubit,
  required WalletCubit walletCubit,
}) async {
  final String? ssiMnemonic =
      await secureStorageProvider.get(SecureStorageKeys.ssiMnemonic);
  if (ssiMnemonic == null || ssiMnemonic.isEmpty) {
    return false;
  }

  final String? ssiKey =
      await secureStorageProvider.get(SecureStorageKeys.ssiKey);
  if (ssiKey == null || ssiKey.isEmpty) {
    return false;
  }

  final String? did = await secureStorageProvider.get(SecureStorageKeys.did);

  if (did == null || did.isEmpty) {
    return false;
  }

  final String? didMethod =
      await secureStorageProvider.get(SecureStorageKeys.didMethod);
  if (didMethod == null || didMethod.isEmpty) {
    return false;
  }

  final String? didMethodName =
      await secureStorageProvider.get(SecureStorageKeys.didMethodName);
  if (didMethodName == null || didMethodName.isEmpty) {
    return false;
  }

  final String? verificationMethod =
      await secureStorageProvider.get(SecureStorageKeys.verificationMethod);
  if (verificationMethod == null || verificationMethod.isEmpty) {
    return false;
  }

  final String? isEnterprise =
      await secureStorageProvider.get(SecureStorageKeys.isEnterpriseUser);

  if (isEnterprise != null && isEnterprise.isNotEmpty) {
    if (isEnterprise == 'true') {
      final rsaKeyJson =
          await secureStorageProvider.get(SecureStorageKeys.rsaKeyJson);
      if (rsaKeyJson == null || rsaKeyJson.isEmpty) {
        return false;
      }
    }
  }

  await walletCubit.initialize();

  final String? currentCryptoIndex =
      await secureStorageProvider.get(SecureStorageKeys.currentCryptoIndex);
  if (currentCryptoIndex != null && currentCryptoIndex.isNotEmpty) {
    /// load active index
    final activeIndex = int.parse(currentCryptoIndex);
    await walletCubit.setCurrentWalletAccount(activeIndex);

    final String? savedCryptoAccount =
        await secureStorageProvider.get(SecureStorageKeys.cryptoAccount);

    if (savedCryptoAccount != null && savedCryptoAccount.isNotEmpty) {
      //load all the content of walletAddress
      final cryptoAccountJson =
          jsonDecode(savedCryptoAccount) as Map<String, dynamic>;
      final CryptoAccount cryptoAccount =
          CryptoAccount.fromJson(cryptoAccountJson);
      walletCubit.emitCryptoAccount(cryptoAccount);
    } else {
      await walletCubit.setCurrentWalletAccount(0);
    }
  } else {
    await walletCubit.createCryptoWallet(
      mnemonicOrKey: ssiMnemonic,
      isImported: false,
    );
    await walletCubit.setCurrentWalletAccount(0);
  }

  await didCubit.load(
    did: did,
    didMethod: didMethod,
    didMethodName: didMethodName,
    verificationMethod: verificationMethod,
  );

  return true;
}
