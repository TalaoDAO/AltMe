import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:dartez/dartez.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

part 'confirm_connection_cubit.g.dart';
part 'confirm_connection_state.dart';

class ConfirmConnectionCubit extends Cubit<ConfirmConnectionState> {
  ConfirmConnectionCubit({
    required this.walletCubit,
    required this.beacon,
    required this.beaconCubit,
    required this.connectedDappRepository,
    required this.walletConnectCubit,
  }) : super(const ConfirmConnectionState());

  final WalletCubit walletCubit;
  final Beacon beacon;
  final BeaconCubit beaconCubit;
  final ConnectedDappRepository connectedDappRepository;
  final WalletConnectCubit walletConnectCubit;

  final log = getLogger('ConfirmConnectionCubit');

  Future<void> connect({
    required ConnectionBridgeType connectionBridgeType,
  }) async {
    if (isClosed) return;
    try {
      emit(state.loading());

      final isInternetAvailable = await isConnectedToInternet();
      if (!isInternetAvailable) {
        throw NetworkException(
          message: NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
        );
      }

      final CryptoAccountData currentAccount =
          walletCubit.state.currentAccount!;

      switch (connectionBridgeType) {
        // TODO(bibash): check if tezos or ethereum

        case ConnectionBridgeType.beacon:
          final KeyStoreModel sourceKeystore =
              getKeysFromSecretKey(secretKey: currentAccount.secretKey);

          log.i('Start connecting to beacon');
          final Map<dynamic, dynamic> response =
              await beacon.permissionResponse(
            id: beaconCubit.state.beaconRequest!.request!.id!,
            publicKey: sourceKeystore.publicKey,
            address: currentAccount.walletAddress,
          );

          final bool success =
              json.decode(response['success'].toString()) as bool;

          if (success) {
            log.i('Connected to beacon');
            final savedPeerData = SavedDappData(
              peer: beaconCubit.state.beaconRequest!.peer,
              walletAddress: currentAccount.walletAddress,
            );
            await connectedDappRepository.insert(savedPeerData);
          } else {
            throw ResponseMessage(
              message:
                  ResponseString.RESPONSE_STRING_FAILED_TO_CONNECT_WITH_BEACON,
            );
          }

        case ConnectionBridgeType.walletconnect:
          final walletConnectState = walletConnectCubit.state;

          final SessionProposalEvent? sessionProposalEvent =
              walletConnectState.sessionProposalEvent;

          final eVMAccounts = walletCubit.state.cryptoAccount.data
              .where((e) => e.blockchainType != BlockchainType.tezos)
              .toList();

          final accounts = <String>[];

          final allowedNamespaces = [
            ...sessionProposalEvent!
                .params.optionalNamespaces['eip155']!.chains!,
            ...sessionProposalEvent
                .params.requiredNamespaces['eip155']!.chains!,
          ];

          log.i(allowedNamespaces);

          for (final evm in eVMAccounts) {
            if (allowedNamespaces.contains(evm.blockchainType.chain)) {
              accounts.add('${evm.blockchainType.chain}:${evm.walletAddress}');
            }
          }

          final walletNamespaces = {
            'eip155': Namespace(
              accounts: accounts,
              methods: Parameters.walletConnectMethods,
              events: Parameters.walletConnectEvents,
            ),
          };

          await walletConnectCubit.web3Wallet!.approveSession(
            id: sessionProposalEvent.id,
            namespaces: walletNamespaces,
          );

        /// dApp saved onSessionConnect function in wallet connect cubit
      }
      emit(
        state.copyWith(
          appStatus: AppStatus.success,
          messageHandler: ResponseMessage(
            message:
                ResponseString.RESPONSE_STRING_SUCCESSFULLY_CONNECTED_TO_BEACON,
          ),
        ),
      );
    } catch (e, s) {
      log.e('error connecting to $connectionBridgeType , e: $e , s: $s');
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

  void rejectConnection({
    required ConnectionBridgeType connectionBridgeType,
  }) {
    if (isClosed) return;
    switch (connectionBridgeType) {
      case ConnectionBridgeType.beacon:
        log.i('beacon connection rejected');
        beacon.permissionResponse(
          id: beaconCubit.state.beaconRequest!.request!.id!,
          publicKey: null,
          address: null,
        );

      case ConnectionBridgeType.walletconnect:
        log.i('walletconnect  connection rejected');
        final walletConnectState = walletConnectCubit.state;

        final SessionProposalEvent? sessionProposalEvent =
            walletConnectState.sessionProposalEvent;

        walletConnectCubit.web3Wallet!.rejectSession(
          id: sessionProposalEvent!.id,
          reason: Errors.getSdkError(
            Errors.USER_REJECTED,
          ),
        );
    }
    emit(state.copyWith(appStatus: AppStatus.goBack));
  }
}
