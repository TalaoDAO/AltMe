import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'manage_network_cubit.g.dart';

part 'manage_network_state.dart';

class ManageNetworkCubit extends Cubit<ManageNetworkState> {
  ManageNetworkCubit({
    required this.secureStorageProvider,
    required this.walletCubit,
  }) : super(ManageNetworkState(network: TezosNetwork.mainNet())) {
    loadNetwork();
  }

  final SecureStorageProvider secureStorageProvider;
  final WalletCubit walletCubit;

  Future<void> loadNetwork() async {
    final blockchainType = walletCubit.state.currentAccount?.blockchainType;

    if (blockchainType == null) return;

    late BlockchainNetwork blockchainNetwork;

    final blockchainNetworkJson = await secureStorageProvider
        .get(SecureStorageKeys.blockChainNetworksIndexing);

    if (blockchainNetworkJson != null) {
      final jsonData =
          json.decode(blockchainNetworkJson) as Map<String, dynamic>;

      final key = blockchainType.name;

      if (jsonData.containsKey(key)) {
        final index = jsonData[key] as int;
        blockchainNetwork = blockchainType.networks[index];
      } else {
        // take index 0 of the current account
        blockchainNetwork = blockchainType.networks[0];
      }
    } else {
      // take index 0 of the current account
      blockchainNetwork = blockchainType.networks[0];
    }

    emit(state.copyWith(network: blockchainNetwork));
  }

  Future<void> setNetwork(BlockchainNetwork network) async {
    if (network == state.network) return;

    final blockchainNetworkJson = await secureStorageProvider
        .get(SecureStorageKeys.blockChainNetworksIndexing);

    late Map<String, dynamic> jsonData;

    if (blockchainNetworkJson != null) {
      jsonData = json.decode(blockchainNetworkJson) as Map<String, dynamic>;
    } else {
      jsonData = <String, dynamic>{};
    }

    final blockchainType = network.type;
    final supportedNetworks = blockchainType.networks;
    final key = blockchainType.name;

    final index = supportedNetworks.indexOf(network);

    /// map with index is saved
    /// {'tezos': 1 , 'ethereum': 1}

    jsonData[key] = index;

    await secureStorageProvider.set(
      SecureStorageKeys.blockChainNetworksIndexing,
      jsonEncode(jsonData),
    );

    emit(state.copyWith(network: network));
  }
}
