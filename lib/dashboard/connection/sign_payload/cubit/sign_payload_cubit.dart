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

  late String encodedPayload;
  SigningType signingType = SigningType.micheline;

  void decodeMessage({
    required ConnectionBridgeType connectionBridgeType,
  }) {
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
            encodedPayload = beaconRequest.request!.payload!;
            signingType = SigningType.micheline;
          } else if (payload.startsWith('03')) {
            encodedPayload = beaconRequest.request!.payload!;
            signingType = SigningType.operation;
          } else {
            encodedPayload = stringToHexPrefixedWith05(payload: payload);
            signingType = SigningType.raw;
          }
          final bytes = hexToBytes(encodedPayload);
          payloadMessage = utf8.decode(bytes, allowMalformed: true);

          break;
        case ConnectionBridgeType.walletconnect:
          // encodedPayload = walletConnectCubit.state.signMessage!.data!;
          // signingType = SigningType.raw;
          // final bytes = hexToBytes(encodedPayload);
          // payloadMessage = utf8.decode(bytes, allowMalformed: true);

          // v2

          if (walletConnectCubit.state.signType == Parameters.PERSONAL_SIGN) {
            payloadMessage = getUtf8Message(
              walletConnectCubit.state.parameters[0] as String,
            );
          } else if (walletConnectCubit.state.signType == Parameters.ETH_SIGN) {
            payloadMessage = getUtf8Message(
              walletConnectCubit.state.parameters[1] as String,
            );
          } else if (walletConnectCubit.state.signType ==
              Parameters.ETH_SIGN_TYPE_DATA) {
            payloadMessage = walletConnectCubit.state.parameters[1] as String;
          } else if (walletConnectCubit.state.signType ==
              Parameters.ETH_SIGN_TRANSACTION) {
            payloadMessage = jsonEncode(walletConnectCubit.state.parameters[0]);
          } else {
            throw ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            );
          }
          signingType = SigningType.raw;
          break;
      }

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
    if (isClosed) return;
    try {
      log.i('Started signing');
      emit(state.loading());

      final isInternetAvailable = await isConnected();
      if (!isInternetAvailable) {
        throw NetworkException(
          message: NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
        );
      }

      bool success = false;

      switch (connectionBridgeType) {
        case ConnectionBridgeType.beacon:
          final BeaconRequest beaconRequest = beaconCubit.state.beaconRequest!;

          final CryptoAccountData? currentAccount =
              walletCubit.state.cryptoAccount.data.firstWhereOrNull(
            (element) =>
                element.walletAddress == beaconRequest.request!.sourceAddress!,
          );

          if (currentAccount == null) {
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

          final Map<dynamic, dynamic> response =
              await beacon.signPayloadResponse(
            id: beaconCubit.state.beaconRequest!.request!.id!,
            signature: signature,
            type: signingType,
          );

          success = json.decode(response['success'].toString()) as bool;

          break;
        case ConnectionBridgeType.walletconnect:
          final walletConnectState = walletConnectCubit.state;
          // final wcClient = walletConnectState.wcClients.firstWhereOrNull(
          //   (element) =>
          //       element.remotePeerId ==
          //       walletConnectCubit.state.currentDappPeerId,
          // );

          // log.i('wcClient -$wcClient');
          // if (wcClient == null) {
          //   throw ResponseMessage(
          //     ResponseString
          //         .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          //   );
          // }

          // final List<SavedDappData> savedDapps =
          //     await connectedDappRepository.findAll();

          // final SavedDappData? dappData = savedDapps.firstWhereOrNull(
          //   (element) {
          //     return element.wcSessionStore != null &&
          //         element.wcSessionStore!.session.key ==
          //             wcClient.sessionStore.session.key;
          //   },
          // );

          // log.i('dappData -$dappData');
          // if (dappData == null) {
          //   throw ResponseMessage(
          //     ResponseString
          //         .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          //   );
          // }

          // final CryptoAccountData? currentAccount =
          //     walletCubit.state.cryptoAccount.data.firstWhereOrNull(
          //   (element) =>
          //       element.walletAddress == dappData.walletAddress &&
          //       element.blockchainType == dappData.blockchainType,
          // );

          // log.i('currentAccount -$currentAccount');
          // // ignore: invariant_booleans
          // if (currentAccount == null) {
          //   throw ResponseMessage(
          //     ResponseString
          //         .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          //   );
          // }

          // log.i('type -${walletConnectCubit.state.signMessage!.type}}');

          // switch (walletConnectCubit.state.signMessage!.type) {
          //   /// rejected in wallet_connect_cubit
          //   case WCSignType.MESSAGE:
          //     break;

          //   /// rejected in wallet_connect_cubit
          //   case WCSignType.TYPED_MESSAGE:
          //     break;

          //   case WCSignType.PERSONAL_MESSAGE:
          //     const messagePrefix = '\u0019Ethereum Signed Message:\n';

          //     final payloadBytes = hexToBytes(encodedPayload);

          //     final prefix = messagePrefix + payloadBytes.length.toString();
          //     final prefixBytes = ascii.encode(prefix);

          //     final concatPayload =
          //         Uint8List.fromList(prefixBytes + payloadBytes);

          //     final Credentials credentials =
          //         EthPrivateKey.fromHex(currentAccount.secretKey);

          //     final MsgSignature signature =
          //         credentials.signToEcSignature(concatPayload);

          //     final String r = signature.r.toRadixString(16);
          //     log.i('r -$r');
          //     final String s = signature.s.toRadixString(16);
          //     log.i('s -$s');
          //     final String v = signature.v.toRadixString(16);
          //     log.i('v -$v');

          //     final signedDataAsHex = '0x$r$s$v';
          //     log.i('signedDataAsHex -$signedDataAsHex');

          //     wcClient.approveRequest<String>(
          //       id: walletConnectState.signId!,
          //       result: signedDataAsHex,
          //     );
          //     success = true;
          //     break;
          // }

          //v2

          final String publicKey;

          /// Extracting secret key
          if (walletConnectCubit.state.signType ==
                  Parameters.ETH_SIGN_TYPE_DATA ||
              walletConnectCubit.state.signType == Parameters.ETH_SIGN) {
            publicKey = walletConnectState.parameters[0].toString();
          } else if (walletConnectCubit.state.signType ==
              Parameters.PERSONAL_SIGN) {
            publicKey = walletConnectState.parameters[1].toString();
          } else if (walletConnectCubit.state.signType ==
              Parameters.ETH_SIGN_TRANSACTION) {
            publicKey = walletConnectState.parameters[0]['from'].toString();
          } else {
            throw ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            );
          }

          final CryptoAccountData? currentAccount =
              walletCubit.state.cryptoAccount.data.firstWhereOrNull(
            (element) => element.walletAddress == publicKey,
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

          /// sign
          if (walletConnectCubit.state.signType == Parameters.PERSONAL_SIGN ||
              walletConnectCubit.state.signType == Parameters.ETH_SIGN) {
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
              Parameters.ETH_SIGN_TYPE_DATA) {
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
              Parameters.ETH_SIGN_TRANSACTION) {
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
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            );
          }

          break;
      }

      if (success) {
        if (state.payloadMessage != null &&
            state.payloadMessage!.contains('#')) {
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
          await qrCodeScanCubit.verify(uri: uri, isScan: false);
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

      if (connectionBridgeType == ConnectionBridgeType.walletconnect) {
        walletConnectCubit.completer[walletConnectCubit.completer.length - 1]!
            .complete('Failed');
      }
    }
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
        break;
      case ConnectionBridgeType.walletconnect:
        log.i('walletconnect Signing rejected');
        // final walletConnectState = walletConnectCubit.state;

        // final wcClient = walletConnectState.wcClients.firstWhereOrNull(
        //   (element) =>
        //       element.remotePeerId ==
        //       walletConnectCubit.state.currentDappPeerId,
        // );

        // if (wcClient != null) {
        //   wcClient.rejectRequest(id: walletConnectState.signId!);
        // }
        walletConnectCubit.completer[walletConnectCubit.completer.length - 1]!
            .complete('Failed');
        break;
    }
    emit(state.copyWith(appStatus: AppStatus.goBack));
  }
}
