import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/beacon/beacon.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'beacon_right_cubit.g.dart';
part 'beacon_right_state.dart';

class BeaconRightCubit extends Cubit<BeaconRightState> {
  BeaconRightCubit({
    required this.beacon,
    required this.beaconRepository,
  }) : super(const BeaconRightState());

  final Beacon beacon;
  final BeaconRepository beaconRepository;

  final log = getLogger('BeaconRightCubit');

  Future<void> disconnect({required String publicKey}) async {
    try {
      log.i('Started disconnecting');
      emit(state.loading());

      final Map response =
          await beacon.removePeerUsingPublicKey(publicKey: publicKey);

      final bool success = json.decode(response['success'].toString()) as bool;

      if (success) {
        log.i('Disconnect success');

        await beaconRepository.deleteByPublicKey(publicKey);
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
          ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
        );
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
