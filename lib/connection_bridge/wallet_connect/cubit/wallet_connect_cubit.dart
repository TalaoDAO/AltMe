import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wallet_connect/wallet_connect.dart';

part 'wallet_connect_cubit.g.dart';
part 'wallet_connect_state.dart';

class WalletConnectCubit extends Cubit<WalletConnectState> {
  WalletConnectCubit() : super(const WalletConnectState());

  final log = getLogger('WalletConnectCubit');

  void connect(String walletConnectUri) {
    log.i('walletConnectUri - $walletConnectUri');
    final WCSession session = WCSession.from(walletConnectUri);
    final WCPeerMeta walletPeerMeta = WCPeerMeta(
      name: 'Altme',
      url: 'https://altme.io',
      description: 'Altme Wallet',
      icons: [],
    );
    log.i('walletPeerMeta: $walletPeerMeta');

    final WCClient? wcClient = createWCClient(session.topic);
    log.i('wcClient: $wcClient');
    if (wcClient == null) return;
    wcClient.connectNewSession(session: session, peerMeta: walletPeerMeta);
    emit(
      state.copyWith(
        status: WalletConnectStatus.idle,
        wcClient: wcClient,
      ),
    );
  }

  WCClient? createWCClient(String? sessionTopic) {
    final String? topic = sessionTopic;
    if (topic == null) return null;

    return WCClient(
      onConnect: () {
        log.i('connected');
      },
      onDisconnect: (code, reason) {
        log.i('onDisconnect');
      },
      onFailure: (dynamic error) {
        log.e('Failed to connect: $error');
      },
      onSessionRequest: (int id, WCPeerMeta dAppPeerMeta) {
        log.i('onSessionRequest');
        log.i('id: $id');
        log.i('dAppPeerMeta: $dAppPeerMeta');
        emit(
          state.copyWith(
            sessionId: id,
            status: WalletConnectStatus.permission,
          ),
        );
      },
      onEthSign: (int id, WCEthereumSignMessage message) {
        //TODO(bibash): verify with current account
        log.i('onEthSign');
        log.i('id: $id');
        log.i('message: $message');
        emit(
          state.copyWith(
            signId: id,
            status: WalletConnectStatus.signPayload,
            signMessage: message,
          ),
        );
      },
      onEthSendTransaction: (id, tx) {
        log.i('onEthSendTransaction');
        log.i('id: $id');
        log.i('tx: $tx');
      },
      onEthSignTransaction: (id, tx) {
        log.i('onEthSignTransaction');
        log.i('id: $id');
        log.i('tx: $tx');
      },
    );
  }
}
