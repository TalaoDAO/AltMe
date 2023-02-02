import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'manage_network_cubit.g.dart';

part 'manage_network_state.dart';

class ManageNetworkCubit extends Cubit<ManageNetworkState> {
  ManageNetworkCubit({required this.secureStorageProvider})
      : super(ManageNetworkState(network: TezosNetwork.mainNet())) {
    _load();
  }

  final SecureStorageProvider secureStorageProvider;

  Future<void> _load() async {
    final blockchainNetworkJson =
        await secureStorageProvider.get(SecureStorageKeys.blockchainNetworkKey);

    late final BlockchainNetwork blockchainNetwork;

    if (blockchainNetworkJson != null) {
      final mJson = json.decode(blockchainNetworkJson) as Map<String, dynamic>;
      if (mJson['chain'] != null) {
        blockchainNetwork = EthereumNetwork.fromJson(mJson);
      } else {
        blockchainNetwork = BlockchainNetwork.fromJson(mJson);
      }
    } else {
      blockchainNetwork = TezosNetwork.mainNet();
    }

    emit(state.copyWith(network: blockchainNetwork));
  }

  Future<void> setNetwork(BlockchainNetwork network) async {
    if (network == state.network) return;
    Map<String, dynamic> networkJson;
    if (network is EthereumNetwork) {
      networkJson = network.toJson();
    } else if (network is TezosNetwork) {
      networkJson = network.toJson();
    } else {
      networkJson = network.toJson();
    }
    await secureStorageProvider.set(
      SecureStorageKeys.blockchainNetworkKey,
      jsonEncode(networkJson),
    );
    emit(state.copyWith(network: network));
  }
}
