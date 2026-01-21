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

      final isInternetAvailable = await isConnectedToInternet();
      if (!isInternetAvailable) {
        throw NetworkException(
          message: NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
        );
      }

      if (savedDappData.walletAddress != null) {
        final Map<dynamic, dynamic> response = await beacon
            .removePeerUsingPublicKey(publicKey: savedDappData.peer!.publicKey);

        final bool success =
            json.decode(response['success'].toString()) as bool;

        if (success) {
          log.i('Disconnect success');
          await connectedDappRepository.delete(savedDappData);
          emit(
            state.copyWith(
              appStatus: AppStatus.success,
              messageHandler: ResponseMessage(
                message: ResponseString.RESPONSE_STRING_DISCONNECTED_FROM_DAPP,
              ),
            ),
          );
        } else {
          throw ResponseMessage(
            message: ResponseString
                .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          );
        }
      } else {
        await walletConnectCubit.disconnectSession(
          savedDappData.sessionData!.pairingTopic,
        );

        await connectedDappRepository.delete(savedDappData);
        emit(
          state.copyWith(
            appStatus: AppStatus.success,
            messageHandler: ResponseMessage(
              message: ResponseString.RESPONSE_STRING_DISCONNECTED_FROM_DAPP,
            ),
          ),
        );
      }
    } catch (e, s) {
      log.e('disconnect failure , e: $e, s: $s');
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              message: ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
        );
      }
    }
  }
}
