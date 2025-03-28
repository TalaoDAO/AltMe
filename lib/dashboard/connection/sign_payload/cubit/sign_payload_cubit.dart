import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:convert/convert.dart';
import 'package:dartez/dartez.dart';
import 'package:equatable/equatable.dart';
import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
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

  late String encodedPayloaForTezos;
  SigningType signingType = SigningType.micheline;

  Future<void> init({
    required ConnectionBridgeType connectionBridgeType,
  }) async {
    if (isClosed) return;
    try {
      emit(state.loading());

      final log = getLogger('SignPayloadCubit');

      String payloadMessage = '';

      switch (connectionBridgeType) {
        case ConnectionBridgeType.beacon:
          log.i('decoding payload');
          final BeaconRequest beaconRequest = beaconCubit.state.beaconRequest!;

          final String payload = beaconRequest.request!.payload!;
          log.i('payload - $payload');
          if (payload.startsWith('05')) {
            encodedPayloaForTezos = beaconRequest.request!.payload!;
            signingType = SigningType.micheline;
          } else if (payload.startsWith('03')) {
            encodedPayloaForTezos = beaconRequest.request!.payload!;
            signingType = SigningType.operation;
          } else {
            encodedPayloaForTezos = stringToHexPrefixedWith05(payload: payload);
            signingType = SigningType.raw;
          }
          final bytes = hexToBytes(encodedPayloaForTezos).filterPayload;

          payloadMessage = utf8.decode(bytes, allowMalformed: true);

        case ConnectionBridgeType.walletconnect:
          if (walletConnectCubit.state.signType == Parameters.PERSONAL_SIGN) {
            payloadMessage = getUtf8Message(
              walletConnectCubit.state.parameters[0] as String,
            );
          } else if (walletConnectCubit.state.signType == Parameters.ETH_SIGN) {
            payloadMessage = getUtf8Message(
              walletConnectCubit.state.parameters[1] as String,
            );
          } else if (walletConnectCubit.state.signType ==
              Parameters.TEZOS_SIGN) {
            final payload = walletConnectCubit.state.parameters['payload'];
            payloadMessage = getUtf8Message(payload.toString());
            encodedPayloaForTezos = payloadMessage;
          } else if (walletConnectCubit.state.signType ==
                  Parameters.ETH_SIGN_TYPE_DATA ||
              walletConnectCubit.state.signType ==
                  Parameters.ETH_SIGN_TYPE_DATA_V4) {
            payloadMessage = walletConnectCubit.state.parameters[1] as String;
          } else if (walletConnectCubit.state.signType ==
              Parameters.ETH_SIGN_TRANSACTION) {
            payloadMessage = jsonEncode(walletConnectCubit.state.parameters[0]);
          } else if (walletConnectCubit.state.signType ==
              Parameters.ETH_SIGN_TRANSACTION) {
            payloadMessage = jsonEncode(walletConnectCubit.state.parameters[0]);
          } else {
            throw ResponseMessage(
              message: ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            );
          }
          signingType = SigningType.raw;
      }

      log.i('payloadMessage - $payloadMessage');

      String dAppName = '';
      switch (connectionBridgeType) {
        case ConnectionBridgeType.beacon:
          dAppName =
              beaconCubit.state.beaconRequest?.request?.appMetadata?.name ?? '';
        case ConnectionBridgeType.walletconnect:
          final List<SavedDappData> savedDapps =
              await connectedDappRepository.findAll();

          final SavedDappData? savedDappData =
              savedDapps.firstWhereOrNull((SavedDappData element) {
            return walletConnectCubit.state.sessionTopic ==
                element.sessionData!.topic;
          });

          if (savedDappData != null) {
            dAppName = savedDappData.sessionData!.peer.metadata.name;
          }
      }

      log.i('dAppName - $dAppName');

      emit(
        state.copyWith(
          status: AppStatus.idle,
          payloadMessage: payloadMessage,
          dAppName: dAppName,
        ),
      );
    } catch (e) {
      log.e('decoding failure , e: $e');
      emit(
        state.error(
          messageHandler: ResponseMessage(
            message: ResponseString.RESPONSE_STRING_payloadFormatErrorMessage,
          ),
        ),
      );
    }
  }

  Future<void> sign({
    required ConnectionBridgeType connectionBridgeType,
  }) async {
    if (isClosed) return;
    try {
      log.i('Started signing');
      emit(state.loading());

      final isInternetAvailable = await isConnectedToInternet();
      if (!isInternetAvailable) {
        throw NetworkException(
          message: NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
        );
      }

      bool success = false;

      switch (connectionBridgeType) {
        case ConnectionBridgeType.beacon:
          final BeaconRequest beaconRequest = beaconCubit.state.beaconRequest!;

          final address = beaconRequest.request!.sourceAddress!;

          final CryptoAccountData? currentAccount =
              walletCubit.getCryptoAccountData(address);

          if (currentAccount == null) {
            return emit(
              state.copyWith(
                status: AppStatus.error,
                message: StateMessage.error(
                  messageHandler: ResponseMessage(
                    message: ResponseString
                        .RESPONSE_STRING_couldNotFindTheAccountWithThisAddress,
                  ),
                  injectedMessage: address,
                ),
              ),
            );
          }

          final String signature = await tezosSigning(currentAccount.secretKey);

          final Map<dynamic, dynamic> response =
              await beacon.signPayloadResponse(
            id: beaconCubit.state.beaconRequest!.request!.id!,
            signature: signature,
            type: signingType,
          );

          success = json.decode(response['success'].toString()) as bool;

        case ConnectionBridgeType.walletconnect:
          final walletConnectState = walletConnectCubit.state;

          final String publicKey;

          /// Extracting secret key
          if (walletConnectCubit.state.signType ==
                  Parameters.ETH_SIGN_TYPE_DATA ||
              walletConnectCubit.state.signType ==
                  Parameters.ETH_SIGN_TYPE_DATA_V4 ||
              walletConnectCubit.state.signType == Parameters.ETH_SIGN) {
            publicKey = walletConnectState.parameters[0].toString();
          } else if (walletConnectCubit.state.signType ==
              Parameters.TEZOS_SIGN) {
            publicKey =
                walletConnectCubit.state.parameters['account'].toString();
          } else if (walletConnectCubit.state.signType ==
              Parameters.PERSONAL_SIGN) {
            publicKey = walletConnectState.parameters[1].toString();
          } else if (walletConnectCubit.state.signType ==
              Parameters.ETH_SIGN_TRANSACTION) {
            publicKey = walletConnectState.parameters[0]['from'].toString();
          } else {
            throw ResponseMessage(
              message: ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            );
          }

          final CryptoAccountData? currentAccount =
              walletCubit.getCryptoAccountData(publicKey);

          log.i('currentAccount -$currentAccount');
          if (currentAccount == null) {
            return emit(
              state.copyWith(
                status: AppStatus.error,
                message: StateMessage.error(
                  messageHandler: ResponseMessage(
                    message: ResponseString
                        .RESPONSE_STRING_couldNotFindTheAccountWithThisAddress,
                  ),
                  injectedMessage: publicKey,
                ),
              ),
            );
          }

          /// sign
          if (walletConnectCubit.state.signType == Parameters.PERSONAL_SIGN ||
              walletConnectCubit.state.signType == Parameters.ETH_SIGN) {
            final Credentials credentials =
                EthPrivateKey.fromHex(currentAccount.secretKey);
            final String signature = hex.encode(
              credentials.signPersonalMessageToUint8List(
                Uint8List.fromList(
                  utf8.encode(state.payloadMessage!),
                ),
              ),
            );
            walletConnectCubit
                .completer[walletConnectCubit.completer.length - 1]!
                .complete('0x$signature');
            success = true;
          } else if (walletConnectCubit.state.signType ==
                  Parameters.ETH_SIGN_TYPE_DATA ||
              walletConnectCubit.state.signType ==
                  Parameters.ETH_SIGN_TYPE_DATA_V4) {
            final signTypedData = EthSigUtil.signTypedData(
              privateKey: currentAccount.secretKey,
              jsonData: state.payloadMessage!,
              version: TypedDataVersion.V4,
            );
            walletConnectCubit
                .completer[walletConnectCubit.completer.length - 1]!
                .complete(signTypedData);
            success = true;
          } else if (walletConnectCubit.state.signType ==
              Parameters.TEZOS_SIGN) {
            final String signature =
                await tezosSigning(currentAccount.secretKey);
            walletConnectCubit
                .completer[walletConnectCubit.completer.length - 1]!
                .complete(signature);
            success = true;
          } else if (walletConnectCubit.state.signType ==
              Parameters.ETH_SIGN_TRANSACTION) {
            final Credentials credentials =
                EthPrivateKey.fromHex(currentAccount.secretKey);
            await dotenv.load();
            final infuraApiKey = dotenv.get('INFURA_API_KEY');
            final ethRpcUrl = Urls.infuraBaseUrl + infuraApiKey;
            final httpClient = Client();

            final Web3Client ethClient = Web3Client(ethRpcUrl, httpClient);

            final Uint8List sig = await ethClient.signTransaction(
              credentials,
              walletConnectCubit.state.transaction!,
            );

            // Sign the transaction
            final String signedTx = hex.encode(sig);

            // Return the signed transaction as a hexadecimal string

            walletConnectCubit
                .completer[walletConnectCubit.completer.length - 1]!
                .complete('0x$signedTx');
            success = true;
          } else {
            throw ResponseMessage(
              message: ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            );
          }
      }

      if (success) {
        if (state.payloadMessage != null &&
            state.payloadMessage!.contains('#')) {
          final String url = state.payloadMessage!.split('#')[1];
          try {
            final uri = Uri.parse(url);
            emit(
              state.copyWith(
                status: AppStatus.success,
                message: StateMessage.success(
                  messageHandler: ResponseMessage(
                    message: ResponseString
                        .RESPONSE_STRING_SUCCESSFULLY_SIGNED_PAYLOAD,
                  ),
                ),
              ),
            );
            await qrCodeScanCubit.verify(uri: uri, isScan: false);
          } catch (e) {
            log.e('Invalid url, e: $e');
            emit(
              state.copyWith(
                status: AppStatus.success,
                message: StateMessage.success(
                  messageHandler: ResponseMessage(
                    message: ResponseString
                        .RESPONSE_STRING_SUCCESSFULLY_SIGNED_PAYLOAD,
                  ),
                ),
              ),
            );
          }
        } else {
          emit(
            state.copyWith(
              status: AppStatus.success,
              message: StateMessage.success(
                messageHandler: ResponseMessage(
                  message: ResponseString
                      .RESPONSE_STRING_SUCCESSFULLY_SIGNED_PAYLOAD,
                ),
              ),
            ),
          );
        }
      } else {
        throw ResponseMessage(
          message: ResponseString.RESPONSE_STRING_FAILED_TO_SIGNED_PAYLOAD,
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
              message: ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
        );
      }
    }
  }

  Future<String> tezosSigning(String secretKey) async {
    final dynamic signer = await Dartez.createSigner(
      Dartez.writeKeyWithHint(secretKey, 'edsk'),
    );

    final signature = Dartez.signPayload(
      signer: signer as SoftSigner,
      payload: encodedPayloaForTezos,
    );

    return signature;
  }

  void rejectSigning({
    required ConnectionBridgeType connectionBridgeType,
  }) {
    if (isClosed) return;
    switch (connectionBridgeType) {
      case ConnectionBridgeType.beacon:
        log.i('beacon Signing rejected');
        beacon.signPayloadResponse(
          id: beaconCubit.state.beaconRequest!.request!.id!,
          signature: null,
        );
      case ConnectionBridgeType.walletconnect:
        log.i('walletconnect Signing rejected');

        walletConnectCubit.completer[walletConnectCubit.completer.length - 1]!
            .complete('Failed');
    }
    emit(state.copyWith(status: AppStatus.goBack));
  }
}
