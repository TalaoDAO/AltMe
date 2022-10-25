import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/beacon/beacon.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:dartez/dartez.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:web3dart/crypto.dart';

part 'beacon_sign_payload_cubit.g.dart';
part 'beacon_sign_payload_state.dart';

class BeaconSignPayloadCubit extends Cubit<BeaconSignPayloadState> {
  BeaconSignPayloadCubit({
    required this.walletCubit,
    required this.beacon,
    required this.beaconCubit,
    required this.qrCodeScanCubit,
  }) : super(const BeaconSignPayloadState());

  final WalletCubit walletCubit;
  final Beacon beacon;
  final BeaconCubit beaconCubit;
  final QRCodeScanCubit qrCodeScanCubit;

  final log = getLogger('BeaconSignPayloadCubit');

  void decodeMessage() {
    try {
      log.i('decoding payload');
      emit(state.loading());

      final BeaconRequest beaconRequest = beaconCubit.state.beaconRequest!;

      final String payload = beaconRequest.request!.payload!;

      late String encodedPayload;

      if (payload.startsWith('05') || payload.startsWith('03')) {
        encodedPayload = beaconRequest.request!.payload!;
      } else {
        encodedPayload = stringToHexPrefixedWith05(payload: payload);
      }

      final bytes = hexToBytes(encodedPayload);
      final String payloadMessage = utf8.decode(bytes, allowMalformed: true);

      emit(
        state.copyWith(
          appStatus: AppStatus.idle,
          payloadMessage: payloadMessage,
          encodedPaylod: encodedPayload,
        ),
      );
    } catch (e) {
      log.e('decoding failure , e: $e');
      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_payloadFormatErrorMessage,
          ),
        ),
      );
    }
  }

  Future<void> sign() async {
    try {
      log.i('Started signing');
      emit(state.loading());

      final BeaconRequest beaconRequest = beaconCubit.state.beaconRequest!;

      final CryptoAccountData? currentAccount =
          walletCubit.state.cryptoAccount.data.firstWhereOrNull(
        (element) =>
            element.walletAddress == beaconRequest.request!.sourceAddress!,
      );

      if (currentAccount == null) {
        // TODO(bibash): account data not available error message may be
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
        );
      }

      final dynamic signer = await Dartez.createSigner(
        Dartez.writeKeyWithHint(currentAccount.secretKey, 'edsk'),
      );

      final signature = Dartez.signPayload(
        signer: signer as SoftSigner,
        payload: state.encodedPaylod!,
      );

      final Map response = await beacon.signPayloadResponse(
        id: beaconCubit.state.beaconRequest!.request!.id!,
        signature: signature,
      );

      if (state.payloadMessage!.contains('#')) {
        final String url = state.payloadMessage!.split('#')[1];
        final uri = Uri.parse(url);
        await qrCodeScanCubit.verify(uri: uri);
      }

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
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_FAILED_TO_SIGNED_PAYLOAD,
        );
      }
    } catch (e) {
      log.e('Signing failure , e: $e');
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

  void rejectSigning() {
    log.i('Signing rejected');
    beacon.signPayloadResponse(
      id: beaconCubit.state.beaconRequest!.request!.id!,
      signature: null,
    );
    emit(state.copyWith(appStatus: AppStatus.goBack));
  }
}
