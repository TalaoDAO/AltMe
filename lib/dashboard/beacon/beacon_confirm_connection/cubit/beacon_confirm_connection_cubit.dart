import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/beacon/beacon.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:dartez/dartez.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'beacon_confirm_connection_cubit.g.dart';
part 'beacon_confirm_connection_state.dart';

class BeaconConfirmConnectionCubit extends Cubit<BeaconConfirmConnectionState> {
  BeaconConfirmConnectionCubit({
    required this.walletCubit,
    required this.beacon,
    required this.beaconCubit,
    required this.beaconRepository,
  }) : super(const BeaconConfirmConnectionState());

  final WalletCubit walletCubit;
  final Beacon beacon;
  final BeaconCubit beaconCubit;
  final BeaconRepository beaconRepository;

  final log = getLogger('BeaconConfirmConnectionCubit');

  Future<void> connect() async {
    try {
      emit(state.loading());
      log.i('Start connecting to beacon');

      final isInternetAvailable = await isConnected();
      if (!isInternetAvailable) {
        throw NetworkException(message:
          NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
        );
      }

      final CryptoAccountData currentAccount = walletCubit.state.currentAccount;
      final KeyStoreModel sourceKeystore =
          getKeysFromSecretKey(secretKey: currentAccount.secretKey);

      final Map response = await beacon.permissionResponse(
        id: beaconCubit.state.beaconRequest!.request!.id!,
        publicKey: sourceKeystore.publicKey,
        address: currentAccount.walletAddress,
      );

      final bool success = json.decode(response['success'].toString()) as bool;

      if (success) {
        log.i('Connected to beacon');
        final savedPeerData = SavedPeerData(
          peer: beaconCubit.state.beaconRequest!.peer!,
          walletAddress: currentAccount.walletAddress,
        );
        await beaconRepository.insert(savedPeerData);
        emit(
          state.copyWith(
            appStatus: AppStatus.success,
            messageHandler: ResponseMessage(
              ResponseString.RESPONSE_STRING_SUCCESSFULLY_CONNECTED_TO_BEACON,
            ),
          ),
        );
      } else {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_FAILED_TO_CONNECT_WITH_BEACON,
        );
      }
    } catch (e) {
      log.e('error connecting to beacon , e: $e');
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
        );
      }
    }
  }

  void rejectConnection() {
    log.i('beacon connection rejected');
    beacon.permissionResponse(
      id: beaconCubit.state.beaconRequest!.request!.id!,
      publicKey: null,
      address: null,
    );
    emit(state.copyWith(appStatus: AppStatus.goBack));
  }
}
