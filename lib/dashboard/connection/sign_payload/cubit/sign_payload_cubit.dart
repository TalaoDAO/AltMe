import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:dartez/dartez.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

part 'sign_payload_cubit.g.dart';
part 'sign_payload_state.dart';

class SignPayloadCubit extends Cubit<SignPayloadState> {
  SignPayloadCubit({
    required this.walletCubit,
    required this.beacon,
    required this.beaconCubit,
    required this.qrCodeScanCubit,
    required this.walletConnectCubit,
    required this.connectedDappRepository,
  }) : super(const SignPayloadState());

  final WalletCubit walletCubit;
  final Beacon beacon;
  final BeaconCubit beaconCubit;
  final QRCodeScanCubit qrCodeScanCubit;
  final WalletConnectCubit walletConnectCubit;
  final ConnectedDappRepository connectedDappRepository;

  final log = getLogger('SignPayloadCubit');

  late String encodedPayload;
  SigningType signingType = SigningType.micheline;

  void decodeMessage({
    required ConnectionBridgeType connectionBridgeType,
  }) {
    try {
      emit(state.loading());

      final log = getLogger('SignPayloadCubit');

      switch (connectionBridgeType) {
        case ConnectionBridgeType.beacon:
          log.i('decoding payload');
          final BeaconRequest beaconRequest = beaconCubit.state.beaconRequest!;

          final String payload = beaconRequest.request!.payload!;
          log.i('payload - $payload');
          if (payload.startsWith('05')) {
            encodedPayload = beaconRequest.request!.payload!;
            signingType = SigningType.micheline;
          } else if (payload.startsWith('03')) {
            encodedPayload = beaconRequest.request!.payload!;
            signingType = SigningType.operation;
          } else {
            encodedPayload = stringToHexPrefixedWith05(payload: payload);
            signingType = SigningType.raw;
          }

          break;
        case ConnectionBridgeType.walletconnect:
          encodedPayload = walletConnectCubit.state.signMessage!.data!;
          signingType = SigningType.raw;
          break;
      }

      final bytes = hexToBytes(encodedPayload);
      final String payloadMessage = utf8.decode(bytes, allowMalformed: true);
      log.i('payloadMessage - $payloadMessage');

      emit(
        state.copyWith(
          appStatus: AppStatus.idle,
          payloadMessage: payloadMessage,
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

  Future<void> sign({
    required ConnectionBridgeType connectionBridgeType,
  }) async {
    try {
      log.i('Started signing');
      emit(state.loading());

      final isInternetAvailable = await isConnected();
      if (!isInternetAvailable) {
        throw NetworkException(
          message: NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
        );
      }

      switch (connectionBridgeType) {
        case ConnectionBridgeType.beacon:
          final BeaconRequest beaconRequest = beaconCubit.state.beaconRequest!;

          final CryptoAccountData? currentAccount =
              walletCubit.state.cryptoAccount.data.firstWhereOrNull(
            (element) =>
                element.walletAddress == beaconRequest.request!.sourceAddress!,
          );

          if (currentAccount == null) {
            // TODO(bibash): account data not available error message may be
            throw ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            );
          }

          final dynamic signer = await Dartez.createSigner(
            Dartez.writeKeyWithHint(currentAccount.secretKey, 'edsk'),
          );

          final signature = Dartez.signPayload(
            signer: signer as SoftSigner,
            payload: encodedPayload,
          );

          final Map response = await beacon.signPayloadResponse(
            id: beaconCubit.state.beaconRequest!.request!.id!,
            signature: signature,
            type: signingType,
          );

          final bool success =
              json.decode(response['success'].toString()) as bool;

          if (success) {
            log.i('Signing success');

            if (state.payloadMessage!.contains('#')) {
              final String url = state.payloadMessage!.split('#')[1];
              final uri = Uri.parse(url);
              emit(
                state.copyWith(
                  appStatus: AppStatus.success,
                  messageHandler: ResponseMessage(
                    ResponseString.RESPONSE_STRING_SUCCESSFULLY_SIGNED_PAYLOAD,
                  ),
                ),
              );
              await qrCodeScanCubit.verify(uri: uri, isBeaconSSI: true);
            } else {
              emit(
                state.copyWith(
                  appStatus: AppStatus.success,
                  messageHandler: ResponseMessage(
                    ResponseString.RESPONSE_STRING_SUCCESSFULLY_SIGNED_PAYLOAD,
                  ),
                ),
              );
            }
          } else {
            throw ResponseMessage(
              ResponseString.RESPONSE_STRING_FAILED_TO_SIGNED_PAYLOAD,
            );
          }
          break;
        case ConnectionBridgeType.walletconnect:
          final walletConnectState = walletConnectCubit.state;
          final wcClient = walletConnectState.wcClients.lastWhereOrNull(
            (element) =>
                element.remotePeerMeta ==
                walletConnectCubit.state.currentDAppPeerMeta,
          );

          log.i('wcClient -$wcClient');
          if (wcClient == null) {
            throw ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            );
          }

          final List<SavedDappData> savedDapps =
              await connectedDappRepository.findAll();

          final SavedDappData? dappData = savedDapps.firstWhereOrNull(
            (element) =>
                element.wcSessionStore!.session.key ==
                wcClient.sessionStore.session.key,
          );

          log.i('dappData -$dappData');
          if (dappData == null) {
            throw ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            );
          }

          final CryptoAccountData? currentAccount =
              walletCubit.state.cryptoAccount.data.firstWhereOrNull(
            (element) => element.walletAddress == dappData.walletAddress,
          );

          log.i('currentAccount -$currentAccount');
          if (currentAccount == null) {
            throw ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            );
          }

          final Credentials credentials =
              EthPrivateKey.fromHex(currentAccount.secretKey);

          await dotenv.load();
          final int WEB3_MAINNET_CHAIN_ID =
              int.parse(dotenv.get('WEB3_MAINNET_CHAIN_ID'));

          final MsgSignature msgSignature = await credentials.signToSignature(
            hexToBytes(encodedPayload),
            chainId: WEB3_MAINNET_CHAIN_ID,
          );

          final String r = msgSignature.r.toRadixString(16);
          log.i('r -$r');
          final String s = msgSignature.s.toRadixString(16);
          log.i('s -$s');
          final String v = (msgSignature.v + 27).toRadixString(16);
          log.i('v -$v');

          final signature = '0x$r$s$v';
          log.i('signature -$signature');

          wcClient.approveRequest<String>(
            id: walletConnectState.signId!,
            result: signature,
          );

          emit(
            state.copyWith(
              appStatus: AppStatus.success,
              messageHandler: ResponseMessage(
                ResponseString.RESPONSE_STRING_SUCCESSFULLY_SIGNED_PAYLOAD,
              ),
            ),
          );
          break;
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

  void rejectSigning({
    required ConnectionBridgeType connectionBridgeType,
  }) {
    switch (connectionBridgeType) {
      case ConnectionBridgeType.beacon:
        log.i('beacon Signing rejected');
        beacon.signPayloadResponse(
          id: beaconCubit.state.beaconRequest!.request!.id!,
          signature: null,
        );
        break;
      case ConnectionBridgeType.walletconnect:
        log.i('walletconnect Signing rejected');
        final walletConnectState = walletConnectCubit.state;

        final wcClient = walletConnectState.wcClients.lastWhereOrNull(
          (element) =>
              element.remotePeerMeta == walletConnectState.currentDAppPeerMeta,
        );
        if (wcClient != null) {
          wcClient.rejectRequest(id: walletConnectState.signId!);
        }
        break;
    }
    emit(state.copyWith(appStatus: AppStatus.goBack));
  }
}
