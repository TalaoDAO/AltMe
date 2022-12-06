import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/beacon/beacon.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:altme/wallet_connect/wallet_connect.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:dartez/dartez.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wallet_connect/wallet_connect.dart';

part 'confirm_connection_cubit.g.dart';
part 'confirm_connection_state.dart';

class ConfirmConnectionCubit extends Cubit<ConfirmConnectionState> {
  ConfirmConnectionCubit({
    required this.walletCubit,
    required this.beacon,
    required this.beaconCubit,
    required this.beaconRepository,
    required this.walletConnectCubit,
  }) : super(const ConfirmConnectionState());

  final WalletCubit walletCubit;
  final Beacon beacon;
  final BeaconCubit beaconCubit;
  final BeaconRepository beaconRepository;
  final WalletConnectCubit walletConnectCubit;

  final log = getLogger('ConfirmConnectionCubit');

  final List<WCClient> wcClients = List.empty(growable: true);

  Future<void> connect({
    required ConnectionBridgeType connectionBridgeType,
  }) async {
    try {
      emit(state.loading());

      final isInternetAvailable = await isConnected();
      if (!isInternetAvailable) {
        throw NetworkException(
          message: NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
        );
      }

      final CryptoAccountData currentAccount = walletCubit.state.currentAccount;

      switch (connectionBridgeType) {

        //TODO(bibash) check if tezos or ethereum

        case ConnectionBridgeType.beacon:
          final KeyStoreModel sourceKeystore =
              getKeysFromSecretKey(secretKey: currentAccount.secretKey);

          log.i('Start connecting to beacon');
          final Map response = await beacon.permissionResponse(
            id: beaconCubit.state.beaconRequest!.request!.id!,
            publicKey: sourceKeystore.publicKey,
            address: currentAccount.walletAddress,
          );

          final bool success =
              json.decode(response['success'].toString()) as bool;

          if (success) {
            log.i('Connected to beacon');
            final savedPeerData = SavedPeerData(
              peer: beaconCubit.state.beaconRequest!.peer!,
              walletAddress: currentAccount.walletAddress,
            );
            await beaconRepository.insert(savedPeerData);
          } else {
            throw ResponseMessage(
              ResponseString.RESPONSE_STRING_FAILED_TO_CONNECT_WITH_BEACON,
            );
          }
          break;
        case ConnectionBridgeType.walletconnect:
          final walletConnectState = walletConnectCubit.state;

          final List<String> walletAddresses = [currentAccount.walletAddress];

          walletConnectState.wcClient!.approveSession(
            accounts: walletAddresses,
            chainId: walletConnectState.wcClient!.chainId,
          );
          break;
      }
      emit(
        state.copyWith(
          appStatus: AppStatus.success,
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_SUCCESSFULLY_CONNECTED_TO_BEACON,
          ),
        ),
      );
    } catch (e) {
      log.e('error connecting to $connectionBridgeType , e: $e');
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

  void rejectConnection({
    required ConnectionBridgeType connectionBridgeType,
  }) {
    switch (connectionBridgeType) {
      case ConnectionBridgeType.beacon:
        log.i('beacon connection rejected');
        beacon.permissionResponse(
          id: beaconCubit.state.beaconRequest!.request!.id!,
          publicKey: null,
          address: null,
        );
        break;
      case ConnectionBridgeType.walletconnect:
        log.i('walletconnect  connection rejected');
        final walletConnectState = walletConnectCubit.state;
        walletConnectState.wcClient!
            .rejectRequest(id: walletConnectState.sessionId!);
        break;
    }
    emit(state.copyWith(appStatus: AppStatus.goBack));
  }
}
