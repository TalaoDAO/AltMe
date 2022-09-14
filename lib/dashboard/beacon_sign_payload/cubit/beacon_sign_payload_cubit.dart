import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/beacon/beacon.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:dartez/dartez.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'beacon_sign_payload_cubit.g.dart';
part 'beacon_sign_payload_state.dart';

class BeaconSignPayloadCubit extends Cubit<BeaconSignPayloadState> {
  BeaconSignPayloadCubit({
    required this.walletCubit,
    required this.beacon,
    required this.beaconCubit,
  }) : super(const BeaconSignPayloadState());

  final WalletCubit walletCubit;
  final Beacon beacon;
  final BeaconCubit beaconCubit;

  final log = getLogger('BeaconSignPayloadCubit');

  Future<void> sign() async {
    log.i('Started signing');
    emit(state.loading());

    final CryptoAccountData currentAccount = walletCubit.state.currentAccount;

    final dynamic signer = await Dartez.createSigner(
      Dartez.writeKeyWithHint(currentAccount.secretKey, 'edsk'),
    );

    //TODO(bibash): Should we sign with current address
    final signature = Dartez.signPayload(
      signer: signer as SoftSigner,
      payload: beaconCubit.state.beaconRequest!.request!.payload!,
    );

    final Map response = await beacon.signPayloadResponse(
      id: beaconCubit.state.beaconRequest!.request!.id!,
      signature: signature,
    );

    final bool success = json.decode(response['success'].toString()) as bool;

    if (success) {
      log.i('Signing success');
      emit(
        state.copyWith(
          appStatus: AppStatus.success,
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_SUCCESSFULLY_SIGNED_PAYLOAD,
          ),
        ),
      );
    } else {
      log.e('Signing failure');
      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_FAILED_TO_SIGNED_PAYLOAD,
          ),
        ),
      );
    }
  }

  void rejectSigning() {
    log.i('Signing rejected');
    beacon.signPayloadResponse(
      id: beaconCubit.state.beaconRequest!.request!.id!,
      signature: null,
    );
    emit(state.copyWith(appStatus: AppStatus.success));
  }
}
