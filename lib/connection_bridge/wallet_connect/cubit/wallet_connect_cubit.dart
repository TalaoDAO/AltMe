import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wallet_connect/wallet_connect.dart';

part 'wallet_connect_cubit.g.dart';
part 'wallet_connect_state.dart';

class WalletConnectCubit extends Cubit<WalletConnectState> {
  WalletConnectCubit({
    required this.connectedDappRepository,
  }) : super(WalletConnectState()) {
    initialise();
  }

  final ConnectedDappRepository connectedDappRepository;

  final log = getLogger('WalletConnectCubit');

  Future<void> initialise() async {
    try {
      log.i('initialise');
      final List<SavedDappData> savedDapps =
          await connectedDappRepository.findAll();
      final ethereumConnectedDapps = List.of(savedDapps).where(
        (element) => element.blockchainType == BlockchainType.ethereum,
      );

      final List<WCClient> wcClients = List.empty(growable: true);
      for (final element in ethereumConnectedDapps) {
        final sessionStore = element.wcSessionStore;
        log.i('sessionStore - $sessionStore');

        final WCClient? wcClient = createWCClient(element.wcSessionStore);

        await wcClient!.connectFromSessionStore(sessionStore!);
        log.i('wcClient: $wcClient');
        wcClients.add(wcClient);
      }
      emit(
        state.copyWith(
          status: WalletConnectStatus.idle,
          wcClients: wcClients,
        ),
      );
    } catch (e) {
      log.e(e);
    }
  }

  Future<void> connect(String walletConnectUri) async {
    log.i('walletConnectUri - $walletConnectUri');
    final WCSession session = WCSession.from(walletConnectUri);
    final WCPeerMeta walletPeerMeta = WCPeerMeta(
      name: 'Altme',
      url: 'https://altme.io',
      description: 'Altme Wallet',
      icons: [],
    );
    log.i('walletPeerMeta: $walletPeerMeta');

    final WCClient? wcClient = createWCClient(null);
    log.i('wcClient: $wcClient');
    if (wcClient == null) return;

    await wcClient.connectNewSession(
      session: session,
      peerMeta: walletPeerMeta,
    );

    final wcClients = List.of(state.wcClients)..add(wcClient);
    emit(
      state.copyWith(
        status: WalletConnectStatus.idle,
        wcClients: wcClients,
      ),
    );
  }

  WCClient? createWCClient(WCSessionStore? sessionStore) {
    WCPeerMeta? currentPeerMeta = sessionStore?.remotePeerMeta;
    return WCClient(
      onConnect: () {
        log.i('connected');
      },
      onDisconnect: (code, reason) {
        log.i('onDisconnect - code: $code reason:  $reason');
      },
      onFailure: (dynamic error) {
        log.e('Failed to connect: $error');
      },
      onSessionRequest: (int id, WCPeerMeta dAppPeerMeta) {
        log.i('onSessionRequest');
        log.i('id: $id');
        log.i('dAppPeerMeta: $dAppPeerMeta');
        currentPeerMeta = dAppPeerMeta;
        emit(
          state.copyWith(
            sessionId: id,
            status: WalletConnectStatus.permission,
            currentDAppPeerMeta: currentPeerMeta,
          ),
        );
      },
      onEthSign: (int id, WCEthereumSignMessage message) {
        log.i('onEthSign');
        log.i('id: $id');
        log.i('message: ${message.raw}');
        log.i('data: ${message.data}');
        log.i('type: ${message.type}');
        log.i('currentDAppPeerMeta: ${currentPeerMeta.toString()}');

        switch (message.type) {
          case WCSignType.MESSAGE:
          case WCSignType.TYPED_MESSAGE:
            final wcClient = state.wcClients.lastWhereOrNull(
              (element) => element.remotePeerMeta == currentPeerMeta,
            );
            if (wcClient != null) {
              wcClient.rejectRequest(id: id);
            }
            break;
          case WCSignType.PERSONAL_MESSAGE:
            emit(
              state.copyWith(
                signId: id,
                status: WalletConnectStatus.signPayload,
                signMessage: message,
                currentDAppPeerMeta: currentPeerMeta,
              ),
            );
            break;
        }
      },
      onEthSendTransaction: (int id, WCEthereumTransaction transaction) {
        log.i('onEthSendTransaction');
        log.i('id: $id');
        log.i('tx: $transaction');
        log.i('currentDAppPeerMeta: ${currentPeerMeta.toString()}');
        emit(
          state.copyWith(
            signId: id,
            status: WalletConnectStatus.operation,
            transactionId: id,
            transaction: transaction,
            currentDAppPeerMeta: currentPeerMeta,
          ),
        );
      },
      onEthSignTransaction: (id, tx) {
        log.i('onEthSignTransaction');
        log.i('id: $id');
        log.i('tx: $tx');
      },
    );
  }
}
