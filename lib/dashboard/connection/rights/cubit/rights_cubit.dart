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
  }) : super(const RightsState());

  final Beacon beacon;
  final ConnectedDappRepository connectedDappRepository;

  final log = getLogger('RightsCubit');

  Future<void> disconnect({required SavedDappData savedDappData}) async {
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
          //savedDappData.wcClient!.disconnect();
          // TODO(bibash): disconnect
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
          final Map response = await beacon.removePeerUsingPublicKey(
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
