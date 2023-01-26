import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rights_cubit.g.dart';
part 'rights_state.dart';

class RightsCubit extends Cubit<RightsState> {
  RightsCubit({
    required this.beacon,
    required this.connectedDappRepository,
    required this.walletConnectCubit,
  }) : super(const RightsState());

  final Beacon beacon;
  final ConnectedDappRepository connectedDappRepository;
  final WalletConnectCubit walletConnectCubit;

  final log = getLogger('RightsCubit');

  Future<void> disconnect({required SavedDappData savedDappData}) async {
    if (isClosed) return;
    try {
      log.i('Started disconnecting');
      emit(state.loading());

      final isInternetAvailable = await isConnected();
      if (!isInternetAvailable) {
        throw NetworkException(
          message: NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
        );
      }

      switch (savedDappData.blockchainType) {
        case BlockchainType.ethereum:
          final walletConnectState = walletConnectCubit.state;
          final wcClient = walletConnectState.wcClients.firstWhereOrNull(
            (element) =>
                element.remotePeerId ==
                walletConnectCubit.state.currentDappPeerId,
          );
          if (wcClient != null) {
            log.i(
              '''disconnected - ${savedDappData.wcSessionStore!.remotePeerMeta}''',
            );
            wcClient.disconnect();
            //remove from collection
          }

          await connectedDappRepository.delete(savedDappData);
          emit(
            state.copyWith(
              appStatus: AppStatus.success,
              messageHandler: ResponseMessage(
                ResponseString.RESPONSE_STRING_DISCONNECTED_FROM_DAPP,
              ),
            ),
          );
          break;
        case BlockchainType.tezos:
          final Map<dynamic, dynamic> response =
              await beacon.removePeerUsingPublicKey(
            publicKey: savedDappData.peer!.publicKey,
          );

          final bool success =
              json.decode(response['success'].toString()) as bool;

          if (success) {
            log.i('Disconnect success');
            await connectedDappRepository.delete(savedDappData);
            emit(
              state.copyWith(
                appStatus: AppStatus.success,
                messageHandler: ResponseMessage(
                  ResponseString.RESPONSE_STRING_DISCONNECTED_FROM_DAPP,
                ),
              ),
            );
          } else {
            throw ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            );
          }
          break;
        case BlockchainType.fantom:
        case BlockchainType.polygon:
        case BlockchainType.binance:
          throw Exception();
      }
    } catch (e) {
      log.e('disconnect failure , e: $e');
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
}
