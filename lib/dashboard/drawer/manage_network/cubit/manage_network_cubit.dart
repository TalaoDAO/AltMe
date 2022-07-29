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
    final _tezosNetworkJson =
        await secureStorageProvider.get(SecureStorageKeys.tezosNetworkKey);
    final tezosNetwork = _tezosNetworkJson != null
        ? TezosNetwork.fromJson(
            json.decode(_tezosNetworkJson) as Map<String, dynamic>,
          )
        : TezosNetwork.mainNet();
    emit(state.copyWith(network: tezosNetwork));
  }

  Future<void> setNetwork(TezosNetwork tezosNetwork) async {
    await secureStorageProvider.set(
      SecureStorageKeys.tezosNetworkKey,
      jsonEncode(tezosNetwork.toJson()),
    );
    emit(state.copyWith(network: tezosNetwork));
  }
}
