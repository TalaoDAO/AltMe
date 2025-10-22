import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
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
    required this.profileCubit,
  }) : super(ManageNetworkState(network: TezosNetwork.mainNet()));

  final SecureStorageProvider secureStorageProvider;
  final WalletCubit walletCubit;
  final ProfileCubit profileCubit;

  Future<void> loadNetwork() async {
    final blockchainType = walletCubit.state.currentAccount?.blockchainType;

    if (blockchainType == null) return;

    late BlockchainNetwork blockchainNetwork;

    final blockchainNetworkJson = await secureStorageProvider.get(
      SecureStorageKeys.blockChainNetworksIndexing,
    );

    if (blockchainNetworkJson != null) {
      final jsonData =
          json.decode(blockchainNetworkJson) as Map<String, dynamic>;

      final key = blockchainType.name;

      if (jsonData.containsKey(key)) {
        final index = jsonData[key] as int;
        blockchainNetwork = blockchainType.networks[index];
        emit(state.copyWith(network: blockchainNetwork));
      } else {
        await addNewNetwork(
          blockchainType: blockchainType,
          networkJsonData: jsonData,
        );
      }
    } else {
      await addNewNetwork(
        blockchainType: blockchainType,
        networkJsonData: <String, dynamic>{},
      );
    }
  }

  Future<void> setNetwork(BlockchainNetwork network) async {
    final blockchainNetworkJson = await secureStorageProvider.get(
      SecureStorageKeys.blockChainNetworksIndexing,
    );

    late Map<String, dynamic> jsonData;

    if (blockchainNetworkJson != null) {
      jsonData = json.decode(blockchainNetworkJson) as Map<String, dynamic>;
    } else {
      jsonData = <String, dynamic>{};
    }

    await saveAndEmitNetwork(network: network, networkJsonData: jsonData);
  }

  Future<void> addNewNetwork({
    required BlockchainType blockchainType,
    required Map<String, dynamic> networkJsonData,
  }) async {
    final profileModel = profileCubit.state.model;
    if (profileModel.profileType == ProfileType.enterprise) {
      final testnet = profileModel.profileSetting.blockchainOptions?.testnet;
      if (testnet != null) {
        final currentNetworkList = blockchainType.networks;
        if (testnet) {
          await saveAndEmitNetwork(
            network: currentNetworkList[1],
            networkJsonData: networkJsonData,
          );
        } else {
          await saveAndEmitNetwork(
            network: currentNetworkList[0],
            networkJsonData: networkJsonData,
          );
        }
      }
    } else {
      final blockchainNetwork = blockchainType.networks[0];
      await saveAndEmitNetwork(
        network: blockchainNetwork,
        networkJsonData: networkJsonData,
      );
    }
  }

  Future<void> saveAndEmitNetwork({
    required BlockchainNetwork network,
    required Map<String, dynamic> networkJsonData,
  }) async {
    final blockchainType = network.type;
    final supportedNetworks = blockchainType.networks;
    final key = blockchainType.name;

    final index = supportedNetworks.indexOf(network);

    /// map with index is saved
    /// {'tezos': 1 , 'ethereum': 1}

    networkJsonData[key] = index;

    await secureStorageProvider.set(
      SecureStorageKeys.blockChainNetworksIndexing,
      jsonEncode(networkJsonData),
    );

    emit(state.copyWith(network: network));
  }

  Future<void> resetOtherNetworks(BlockchainNetwork network) async {
    final blockchainType = walletCubit.state.currentAccount?.blockchainType;

    if (blockchainType == null) return;

    final supportedNetworks = blockchainType.networks;
    final key = blockchainType.name;

    final index = supportedNetworks.indexOf(network);
    final networkJsonData = {key: index};
    await secureStorageProvider.set(
      SecureStorageKeys.blockChainNetworksIndexing,
      jsonEncode(networkJsonData),
    );
  }
}
