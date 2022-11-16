import 'dart:convert';

import 'package:altme/app/logger/logger.dart';
import 'package:altme/app/shared/constants/constants.dart';
import 'package:altme/blockchain/cubit/blockchain_cubit.dart';
import 'package:altme/did/did.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:secure_storage/secure_storage.dart';

Future<bool> isWalletCreated({
  required SecureStorageProvider secureStorageProvider,
  required DIDCubit didCubit,
  required WalletCubit walletCubit,
  required BlockchainCubit blockchainCubit,
}) async {
  final log = getLogger('IsWalletCreated');

  log.i('did initialisation');
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

  log.i('wallet initialisation');
  await walletCubit.initialize(ssiKey: ssiKey);

  log.i('blockchain initialisation');
  await blockchainCubit.initialize(
    walletCubit: walletCubit,
    ssiMnemonic: ssiMnemonic,
  );

  await didCubit.load(
    did: did,
    didMethod: didMethod,
    didMethodName: didMethodName,
    verificationMethod: verificationMethod,
  );

  return true;
}
