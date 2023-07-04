import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:convert/convert.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:wallet_connect/wallet_connect.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:web3dart/web3dart.dart';

part 'wallet_connect_cubit.g.dart';
part 'wallet_connect_state.dart';

class WalletConnectCubit extends Cubit<WalletConnectState> {
  WalletConnectCubit({
    required this.connectedDappRepository,
    required this.secureStorageProvider,
  }) : super(WalletConnectState()) {
    initialise();
  }

  final ConnectedDappRepository connectedDappRepository;
  final SecureStorageProvider secureStorageProvider;

  final log = getLogger('WalletConnectCubit');

  Web3Wallet? _web3Wallet;

  Web3Wallet? get web3Wallet => _web3Wallet;

  Future<void> initialise() async {
    try {
      _web3Wallet = null;
      //log.i('initialise');
      // final List<SavedDappData> savedDapps =
      //     await connectedDappRepository.findAll();

      // final connectedDapps = List.of(savedDapps).where(
      //   (element) => element.blockchainType != BlockchainType.tezos,
      // );

      // Await the initialization of the web3wallet

      // final List<WCClient> wcClients = List.empty(growable: true);
      // for (final element in connectedDapps) {
      //   final sessionStore = element.wcSessionStore;

      //   final WCClient? wcClient = createWCClient(element.wcSessionStore);

      //   await wcClient!.connectFromSessionStore(sessionStore!);
      //   log.i('sessionStore: ${wcClient.sessionStore.toJson()}');
      //   wcClients.add(wcClient);
      //}

      // emit(
      //   state.copyWith(
      //     status: WalletConnectStatus.idle,
      //     // wcClients: wcClients,
      //   ),
      // );

      final String? savedCryptoAccount =
          await secureStorageProvider.get(SecureStorageKeys.cryptoAccount);

      log.i('Create the web3wallet');
      await dotenv.load();
      final projectId = dotenv.get('WALLET_CONNECT_PROJECT_ID');
      _web3Wallet = await Web3Wallet.createInstance(
        relayUrl:
            'wss://relay.walletconnect.com', // The relay websocket URL, leave blank to use the default
        projectId: projectId,
        metadata: const PairingMetadata(
          name: 'Wallet (Altme)',
          description: 'Altme Wallet',
          url: 'https://altme.io',
          icons: [],
        ),
      );

      log.i('Setup our accounts');

      if (savedCryptoAccount != null && savedCryptoAccount.isNotEmpty) {
        //load all the content of walletAddress
        final cryptoAccountJson =
            jsonDecode(savedCryptoAccount) as Map<String, dynamic>;
        final CryptoAccount cryptoAccount =
            CryptoAccount.fromJson(cryptoAccountJson);

        final eVMAccounts = cryptoAccount.data
            .where((e) => e.blockchainType != BlockchainType.tezos)
            .toList();

        final events = ['chainChanged', 'accountsChanged'];

        for (final accounts in eVMAccounts) {
          log.i(accounts.blockchainType);

          log.i('registerEventEmitter');
          for (final String event in events) {
            _web3Wallet!.registerEventEmitter(
              chainId: accounts.blockchainType.chain,
              event: event,
            );
          }

          registerAccount(accounts);

          log.i('registerRequestHandler');
          _web3Wallet!.registerRequestHandler(
            chainId: accounts.blockchainType.chain,
            method: Parameters.PERSONAL_SIGN,
            handler: personalSign,
          );
          _web3Wallet!.registerRequestHandler(
            chainId: accounts.blockchainType.chain,
            method: Parameters.ETH_SIGN,
            handler: ethSign,
          );
          _web3Wallet!.registerRequestHandler(
            chainId: accounts.blockchainType.chain,
            method: Parameters.ETH_SIGN_TRANSACTION,
            handler: ethSignTransaction,
          );
          _web3Wallet!.registerRequestHandler(
            chainId: accounts.blockchainType.chain,
            method: Parameters.ETH_SIGN_TYPE_DATA,
            handler: ethSignTypedData,
          );
          _web3Wallet!.registerRequestHandler(
            chainId: accounts.blockchainType.chain,
            method: Parameters.ETH_SEND_TRANSACTION,
            handler: ethSendTransaction,
          );
        }
      }

      log.i('Setup our listeners');
      _web3Wallet!.core.pairing.onPairingInvalid.subscribe(_onPairingInvalid);
      _web3Wallet!.core.pairing.onPairingCreate.subscribe(_onPairingCreate);
      _web3Wallet!.pairings.onSync.subscribe(_onPairingsSync);
      _web3Wallet!.onSessionProposal.subscribe(_onSessionProposal);
      _web3Wallet!.onSessionProposalError.subscribe(_onSessionProposalError);
      _web3Wallet!.onSessionConnect.subscribe(_onSessionConnect);
      _web3Wallet!.onAuthRequest.subscribe(_onAuthRequest);

      log.i('web3wallet init');
      await _web3Wallet!.init();
      log.i('metadata');
      log.i(_web3Wallet!.metadata);

      log.i('pairings');
      log.i(_web3Wallet!.pairings.getAll());
      log.i('sessions');
      log.i(_web3Wallet!.sessions.getAll());
      log.i('completeRequests');
      log.i(_web3Wallet!.completeRequests.getAll());
    } catch (e) {
      log.e(e);
    }
  }

  void registerAccount(CryptoAccountData cryptoAccountData) {
    log.i('registerAccount - $cryptoAccountData');
    _web3Wallet!.registerAccount(
      chainId: cryptoAccountData.blockchainType.chain,
      accountAddress: cryptoAccountData.walletAddress,
    );
  }

  Future<void> connect(String walletConnectUri) async {
    log.i('walletConnectUri - $walletConnectUri');
    // final WCSession session = WCSession.from(walletConnectUri);
    // final WCPeerMeta walletPeerMeta = WCPeerMeta(
    //   name: 'Altme',
    //   url: 'https://altme.io',
    //   description: 'Altme Wallet',
    //   icons: [],
    // );

    // final WCClient? wcClient = createWCClient(null);
    // log.i('wcClient: $wcClient');
    // if (wcClient == null) return;

    // await wcClient.connectNewSession(
    //   session: session,
    //   peerMeta: walletPeerMeta,
    // );

    // final wcClients = List.of(state.wcClients)..add(wcClient);
    // emit(
    //   state.copyWith(
    //     status: WalletConnectStatus.idle,
    //     wcClients: wcClients,
    //   ),
    // );
    final Uri uriData = Uri.parse(walletConnectUri);
    final PairingInfo pairingInfo = await _web3Wallet!.pair(
      uri: uriData,
    );
    log.i(pairingInfo);
  }

  WCClient? createWCClient(WCSessionStore? sessionStore) {
    WCPeerMeta? currentPeerMeta = sessionStore?.remotePeerMeta;
    String? currentPeerId = sessionStore?.remotePeerId;
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
      onSessionRequest: (int id, String dAppPeerId, WCPeerMeta dAppPeerMeta) {
        log.i('onSessionRequest');
        log.i('id: $id');

        currentPeerId = dAppPeerId;
        currentPeerMeta = dAppPeerMeta;

        log.i('dAppPeerId: $currentPeerId');
        log.i('currentDAppPeerMeta: $currentPeerMeta');
        emit(
          state.copyWith(
            sessionId: id,
            status: WalletConnectStatus.permission,
            currentDappPeerId: dAppPeerId,
            currentDAppPeerMeta: currentPeerMeta,
          ),
        );
      },
      onEthSign: (int id, WCEthereumSignMessage message) {
        log.i('onEthSign');
        log.i('id: $id');
        //log.i('message: ${message.raw}');
        log.i('data: ${message.data}');
        log.i('type: ${message.type}');
        log.i('dAppPeerId: $currentPeerId');
        log.i('currentDAppPeerMeta: $currentPeerMeta');

        switch (message.type) {
          case WCSignType.MESSAGE:
          case WCSignType.TYPED_MESSAGE:
            final wcClient = state.wcClients.firstWhereOrNull(
              (element) => element.remotePeerId == currentPeerId,
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
                currentDappPeerId: currentPeerId,
                currentDAppPeerMeta: currentPeerMeta,
              ),
            );
            break;
        }
      },
      onEthSendTransaction: (int id, WCEthereumTransaction wcTransaction) {
        log.i('onEthSendTransaction');
        log.i('id: $id');
        log.i('tx: $wcTransaction');
        log.i('dAppPeerId: $currentPeerId');
        log.i('currentDAppPeerMeta: $currentPeerMeta');
        emit(
          state.copyWith(
            signId: id,
            status: WalletConnectStatus.operation,
            transactionId: id,
            wcTransaction: wcTransaction,
            currentDappPeerId: currentPeerId,
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

  void _onPairingInvalid(PairingInvalidEvent? args) {
    log.i('Pairing Invalid Event: $args');
  }

  void _onPairingsSync(StoreSyncEvent? args) {
    if (args != null) {
      //pairings.value = _web3Wallet!.pairings.getAll();
      log.i('onPairingsSync');
      log.i(_web3Wallet!.pairings.getAll());
    }
  }

  void _onSessionProposal(SessionProposalEvent? args) {
    log.i('onSessionProposal');
    if (args != null) {
      log.i('sessionProposalEvent - $args');
      emit(
        state.copyWith(
          status: WalletConnectStatus.permission,
          sessionProposalEvent: args,
        ),
      );
    }
  }

  void _onSessionProposalError(SessionProposalErrorEvent? args) {
    log.i('onSessionProposalError');
    log.i(args);
  }

  void _onSessionConnect(SessionConnect? args) {
    if (args != null) {
      log.i(args);
      //sessions.value.add(args.session);

      final savedDappData = SavedDappData(sessionData: args.session);

      log.i(savedDappData.toJson());
      connectedDappRepository.insert(savedDappData);
    }
  }

  void _onPairingCreate(PairingEvent? args) {
    log.i('Pairing Create Event: $args');
  }

  Future<void> _onAuthRequest(AuthRequest? args) async {
    if (args != null) {
      print(args);
      // List<ChainKey> chainKeys = GetIt.I<IKeyService>().getKeysForChain(
      //   'eip155:1',
      // );
      // Create the message to be signed
      //final String iss = 'did:pkh:eip155:1:${chainKeys.first.publicKey}';

      // print(args);
      //   final Widget w = WCRequestWidget(
      //     child: WCConnectionRequestWidget(
      //       wallet: _web3Wallet!,
      //       authRequest: WCAuthRequestModel(
      //         iss: iss,
      //         request: args,
      //       ),
      //     ),
      //   );
      //   final bool? auth = await _bottomSheetHandler.queueBottomSheet(
      //     widget: w,
      //   );

      //   if (auth != null && auth) {
      //     final String message = _web3Wallet!.formatAuthMessage(
      //       iss: iss,
      //       cacaoPayload: CacaoRequestPayload.fromPayloadParams(
      //         args.payloadParams,
      //       ),
      //     );

      //     // EthPrivateKey credentials =
      //     //     EthPrivateKey.fromHex(chainKeys.first.privateKey);
      //     // final String sig = utf8.decode(
      //     //   credentials.signPersonalMessageToUint8List(
      //     //     Uint8List.fromList(message.codeUnits),
      //     //   ),
      //     // );

      //     final String sig = EthSigUtil.signPersonalMessage(
      //       message: Uint8List.fromList(message.codeUnits),
      //       privateKey: chainKeys.first.privateKey,
      //     );

      //     await _web3Wallet!.respondAuthRequest(
      //       id: args.id,
      //       iss: iss,
      //       signature: CacaoSignature(
      //         t: CacaoSignature.EIP191,
      //         s: sig,
      //       ),
      //     );
      //   } else {
      //     await _web3Wallet!.respondAuthRequest(
      //       id: args.id,
      //       iss: iss,
      //       error: Errors.getSdkError(
      //         Errors.USER_REJECTED_AUTH,
      //       ),
      //     );
      //   }
      // }
    }
  }

  List<Completer<String>?> completer = <Completer<String>?>[];

  Future<String> personalSign(String topic, dynamic parameters) async {
    log.i('received personal sign request: $parameters');
    log.i('topic: $topic');

    log.i('completer initialise');
    completer.add(Completer<String>());

    emit(
      state.copyWith(
        status: WalletConnectStatus.signPayload,
        parameters: parameters,
        signType: Parameters.PERSONAL_SIGN,
      ),
    );

    final String result = await completer[completer.length - 1]!.future;
    log.i('complete - $result');
    completer.removeLast();
    return result;
  }

  Future<String> ethSign(String topic, dynamic parameters) async {
    log.i('received eth sign request: $parameters');

    log.i('completer initialise');
    completer.add(Completer<String>());

    emit(
      state.copyWith(
        status: WalletConnectStatus.signPayload,
        parameters: parameters,
        signType: Parameters.ETH_SIGN,
      ),
    );

    final String result = await completer[completer.length - 1]!.future;
    log.i('complete - $result');
    completer.removeLast();
    return result;
  }

  Future<String> ethSignTransaction(String topic, dynamic parameters) async {
    log.i('received eth sign transaction request: $parameters');

    log.i('completer initialise');
    completer.add(Completer<String>());

    final transaction = getTransaction(parameters);

    emit(
      state.copyWith(
        status: WalletConnectStatus.signPayload,
        parameters: parameters,
        signType: Parameters.ETH_SIGN_TRANSACTION,
        transaction: transaction,
      ),
    );

    final String result = await completer[completer.length - 1]!.future;
    log.i('complete - $result');
    completer.removeLast();
    return result;
  }

  Future<String> ethSendTransaction(String topic, dynamic parameters) async {
    log.i('received eth send transaction request: $parameters');

    log.i('completer initialise');
    completer.add(Completer<String>());

    final transaction = getTransaction(parameters);

    emit(
      state.copyWith(
        status: WalletConnectStatus.operation,
        parameters: parameters,
        signType: Parameters.ETH_SIGN_TRANSACTION,
        transaction: transaction,
      ),
    );

    final String result = await completer[completer.length - 1]!.future;
    log.i('complete - $result');
    completer.removeLast();
    return result;
  }

  Transaction getTransaction(dynamic parameters) {
    final EthereumTransaction ethTransaction = EthereumTransaction.fromJson(
      parameters[0] as Map<String, dynamic>,
    );

    // Construct a transaction from the EthereumTransaction object
    final transaction = Transaction(
      from: EthereumAddress.fromHex(ethTransaction.from),
      to: EthereumAddress.fromHex(ethTransaction.to),
      value: EtherAmount.fromBigInt(
        EtherUnit.wei,
        BigInt.tryParse(ethTransaction.value) ?? BigInt.zero,
      ),
      gasPrice: ethTransaction.gasPrice != null
          ? EtherAmount.fromBigInt(
              EtherUnit.gwei,
              BigInt.tryParse(ethTransaction.gasPrice!) ?? BigInt.zero,
            )
          : null,
      maxFeePerGas: ethTransaction.maxFeePerGas != null
          ? EtherAmount.fromBigInt(
              EtherUnit.gwei,
              BigInt.tryParse(ethTransaction.maxFeePerGas!) ?? BigInt.zero,
            )
          : null,
      maxPriorityFeePerGas: ethTransaction.maxPriorityFeePerGas != null
          ? EtherAmount.fromBigInt(
              EtherUnit.gwei,
              BigInt.tryParse(ethTransaction.maxPriorityFeePerGas!) ??
                  BigInt.zero,
            )
          : null,
      maxGas: int.tryParse(ethTransaction.gasLimit ?? ''),
      nonce: int.tryParse(ethTransaction.nonce ?? ''),
      data: (ethTransaction.data != null && ethTransaction.data != '0x')
          ? Uint8List.fromList(hex.decode(ethTransaction.data!))
          : null,
    );

    return transaction;
  }

  Future<String> ethSignTypedData(String topic, dynamic parameters) async {
    log.i('received eth sign typed data request: $parameters');

    log.i('completer initialise');
    completer.add(Completer<String>());

    emit(
      state.copyWith(
        status: WalletConnectStatus.signPayload,
        parameters: parameters,
        signType: Parameters.ETH_SIGN_TYPE_DATA,
      ),
    );

    final String result = await completer[completer.length - 1]!.future;
    log.i('complete - $result');
    completer.removeLast();
    return result;
  }

  Future<void> disconnectSession(String topic) async {
    log.i('disconnectSession: $topic');
    await _web3Wallet!.disconnectSession(
      topic: topic,
      reason: Errors.getSdkError(Errors.USER_DISCONNECTED),
    );
  }

  Future<void> dispose() async {
    log.i('web3wallet dispose');
    _web3Wallet!.core.pairing.onPairingInvalid.unsubscribe(_onPairingInvalid);
    _web3Wallet!.pairings.onSync.unsubscribe(_onPairingsSync);
    _web3Wallet!.onSessionProposal.unsubscribe(_onSessionProposal);
    _web3Wallet!.onSessionProposalError.unsubscribe(_onSessionProposalError);
    _web3Wallet!.onSessionConnect.unsubscribe(_onSessionConnect);
    // _web3Wallet!.onSessionRequest.unsubscribe(_onSessionRequest);
    _web3Wallet!.onAuthRequest.unsubscribe(_onAuthRequest);
  }
}
