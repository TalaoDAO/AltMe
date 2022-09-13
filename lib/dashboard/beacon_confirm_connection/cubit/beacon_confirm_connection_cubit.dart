import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tezart/tezart.dart';

part 'beacon_confirm_connection_cubit.g.dart';
part 'beacon_confirm_connection_state.dart';

class BeaconConfirmConnectionCubit extends Cubit<BeaconConfirmConnectionState> {
  BeaconConfirmConnectionCubit({
    required this.walletCubit,
    required this.beacon,
    required this.beaconRequest,
  }) : super(const BeaconConfirmConnectionState());

  final WalletCubit walletCubit;
  final Beacon beacon;
  final BeaconRequest beaconRequest;

  Future<void> connect() async {
    emit(state.loading());
    final CryptoAccountData currentAccount = walletCubit.state.currentAccount;
    final sourceKeystore = Keystore.fromSecretKey(currentAccount.secretKey);

    final Map response = await beacon.permissionResponse(
      id: beaconRequest.request!.id!,
      publicKey: sourceKeystore.publicKey,
      address: currentAccount.walletAddress,
    );

    final bool success = json.decode(response['success'].toString()) as bool;

    if (success) {
      emit(
        state.copyWith(
          appStatus: AppStatus.success,
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_SUCCESSFULLY_CONNECTED_TO_BEACON,
          ),
        ),
      );
    } else {
      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_FAILED_TO_CONNECT_WITH_BEACON,
          ),
        ),
      );
    }
  }

  void rejectConnection() {
    beacon.permissionResponse(
      id: beaconRequest.request!.id!,
      publicKey: null,
      address: null,
    );
    emit(state.copyWith(appStatus: AppStatus.success));
  }
}
