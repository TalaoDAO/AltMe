import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'blockchain_cubit.g.dart';
part 'blockchain_state.dart';

class BlockchainCubit extends Cubit<BlockchainState> {
  BlockchainCubit({
    required this.secureStorageProvider,
  }) : super(const BlockchainState());

  final SecureStorageProvider secureStorageProvider;

  Future<void> set({required BlockchainType blockchainType}) async {
    final log = getLogger('BlockchainCubit - set');

    await secureStorageProvider.set(
      SecureStorageKeys.blockchainType,
      describeEnum(blockchainType),
    );

    emit(
      state.copyWith(
        status: AppStatus.success,
        blockchainType: blockchainType,
      ),
    );
    log.i('successfully Set - $blockchainType');
  }

  Future<void> initialize({
    required WalletCubit walletCubit,
    required String ssiMnemonic,
  }) async {
    final log = getLogger('BlockchainCubit - initialise');

    final String blockchain =
        await secureStorageProvider.get(SecureStorageKeys.blockchainType) ??
            describeEnum(BlockchainType.tezos);

    if (blockchain == describeEnum(BlockchainType.tezos)) {
      emit(
        state.copyWith(
          status: AppStatus.success,
          blockchainType: BlockchainType.tezos,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: AppStatus.success,
          blockchainType: BlockchainType.ethereum,
        ),
      );
    }

    log.i('tezos initialisation');
    // TODO(bibash): currentCryptoIndex => currentTezosIndex & currentEthIndex
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
    }

    log.i('successfully Loaded - $blockchain');
  }
}
