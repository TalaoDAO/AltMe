// ignore_for_file: inference_failure_on_instance_creation

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/key_generator/key_generator.dart';
import 'package:altme/route/route.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:reown_walletkit/reown_walletkit.dart';
import 'package:secure_storage/secure_storage.dart';

part 'wallet_connect_cubit.g.dart';
part 'wallet_connect_state.dart';

class WalletConnectCubit extends Cubit<WalletConnectState> {
  WalletConnectCubit({
    required this.connectedDappRepository,
    required this.secureStorageProvider,
    required this.routeCubit,
    required this.walletCubit,
  }) : super(const WalletConnectState()) {
    initialise();
  }

  final ConnectedDappRepository connectedDappRepository;
  final SecureStorageProvider secureStorageProvider;
  final RouteCubit routeCubit;
  final WalletCubit walletCubit;

  Map<String, dynamic Function(String, dynamic)> get sessionRequestHandlers => {
        Parameters.ETH_SIGN: ethSign,
        Parameters.ETH_SIGN_TRANSACTION: ethSignTransaction,
        Parameters.ETH_SIGN_TYPE_DATA: ethSignTypedData,
        Parameters.ETH_SIGN_TYPE_DATA_V4: ethSignTypedDataV4,
        // SupportedEVMMethods.switchChain.name: switchChain,
        // 'wallet_addEthereumChain': addChain,
        Parameters.TEZOS_GET_ACCOUNTS: tezosGetAccounts,
        Parameters.TEZOS_SIGN: tezosSign,
        Parameters.TEZOS_SEND: tezosSend,
      };

  Map<String, dynamic Function(String, dynamic)> get methodRequestHandlers => {
        Parameters.PERSONAL_SIGN: personalSign,
        Parameters.ETH_SEND_TRANSACTION: ethSendTransaction,
      };

  final log = getLogger('WalletConnectCubit');

  ReownWalletKit? _reownWalletKit;

  ReownWalletKit? get reownWalletKit => _reownWalletKit;

  Future<void> initialise() async {
    try {
      _reownWalletKit = null;

      final String? savedCryptoAccount =
          await secureStorageProvider.get(SecureStorageKeys.cryptoAccount);

      log.i('Create the web3wallet');
      await dotenv.load();
      final projectId = dotenv.get('WALLET_CONNECT_PROJECT_ID');

      _reownWalletKit = ReownWalletKit(
        core: ReownCore(
          projectId: projectId,
          relayUrl:
              'wss://relay.walletconnect.com', // The relay websocket URL, leave blank to use the default
        ),
        metadata: const PairingMetadata(
          name: 'Wallet (Altme)',
          description: 'Altme Wallet',
          url: 'https://altme.io',
          icons: [],
        ),
      );

      log.i('Setup our listeners');
      _reownWalletKit!.core.pairing.onPairingInvalid
          .subscribe(_onPairingInvalid);
      _reownWalletKit!.core.pairing.onPairingCreate.subscribe(_onPairingCreate);
      _reownWalletKit!.pairings.onSync.subscribe(_onPairingsSync);
      _reownWalletKit!.onSessionProposal.subscribe(_onSessionProposal);
      _reownWalletKit!.onSessionProposalError
          .subscribe(_onSessionProposalError);
      _reownWalletKit!.onSessionConnect.subscribe(_onSessionConnect);
      _reownWalletKit!.onSessionAuthRequest.subscribe(_onAuthRequest);

      log.i('web3wallet init');
      await _reownWalletKit!.init();

      log.i('Setup our accounts');

      if (savedCryptoAccount != null && savedCryptoAccount.isNotEmpty) {
        //load all the content of walletAddress
        final cryptoAccountJson =
            jsonDecode(savedCryptoAccount) as Map<String, dynamic>;
        final CryptoAccount cryptoAccount =
            CryptoAccount.fromJson(cryptoAccountJson);

        final cryptoAccounts = cryptoAccount.data.toList();

        log.i('registering acconts');
        for (final accounts in cryptoAccounts) {
          var chain = '';

          if (accounts.blockchainType == BlockchainType.tezos) {
            chain = 'tezos:mainnet';
          } else {
            chain = accounts.blockchainType.chain;
          }

          _reownWalletKit!.registerAccount(
            chainId: chain,
            accountAddress: accounts.walletAddress,
          );
        }
      }

      /// register request emitter and request handler for all supported evms

      for (final blockchainType in BlockchainType.values) {
        log.i(blockchainType);

        var chain = '';

        if (blockchainType == BlockchainType.tezos) {
          chain = 'tezos:mainnet';
        } else {
          chain = blockchainType.chain;
        }

        log.i('registerEventEmitter');
        registerEventEmitter(chain);

        log.i('registerRequestHandler');
        registerRequestHandler(chain);
      }

      _reownWalletKit!.onSessionRequest.subscribe(_onSessionRequest);

      log.i('metadata');
      log.i(_reownWalletKit!.metadata);

      log.i('pairings');
      log.i(_reownWalletKit!.pairings.getAll());
      log.i('sessions');
      log.i(_reownWalletKit!.sessions.getAll());
      // log.i('completeRequests');
      // log.i(_reownWalletKit!.completeRequests.getAll());
    } catch (e) {
      log.e(e);
    }
  }

  void registerRequestHandler(String chain) {
    for (final handler in methodRequestHandlers.entries) {
      _reownWalletKit!.registerRequestHandler(
        chainId: chain,
        method: handler.key,
        handler: handler.value,
      );
    }
    for (final handler in sessionRequestHandlers.entries) {
      _reownWalletKit!.registerRequestHandler(
        chainId: chain,
        method: handler.key,
        handler: handler.value,
      );
    }
  }

  void registerEventEmitter(String chain) {
    for (final String event in Parameters.allEvents) {
      _reownWalletKit!.registerEventEmitter(chainId: chain, event: event);
    }
  }

  Future<void> connect(String walletConnectUri) async {
    log.i('walletConnectUri - $walletConnectUri');

    final Uri uriData = Uri.parse(walletConnectUri);
    final PairingInfo pairingInfo = await _reownWalletKit!.pair(
      uri: uriData,
    );
    log.i(pairingInfo);
  }

  void _onPairingInvalid(PairingInvalidEvent? args) {
    log.i('Pairing Invalid Event: $args');
  }

  void _onPairingsSync(StoreSyncEvent? args) {
    if (args != null) {
      //pairings.value = _reownWalletKit!.pairings.getAll();
      log.i('onPairingsSync');
      log.i(_reownWalletKit!.pairings.getAll());
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
    final requiredChains = args?.requiredNamespaces['eip155']?.chains;

    if (requiredChains != null && requiredChains.isNotEmpty) {
      final requiredChain = requiredChains[0];

      String value = requiredChain;

      for (final evm in BlockchainType.values) {
        if (evm == BlockchainType.tezos) continue;

        if (evm.chain == value) {
          value = evm.name;
          break;
        }
      }
      emit(
        state.copyWith(
          status: WalletConnectStatus.error,
          message: StateMessage.error(
            messageHandler: ResponseMessage(
              message:
                  ResponseString.RESPONSE_STRING_pleaseAddXtoConnectToTheDapp,
            ),
            injectedMessage: value,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: WalletConnectStatus.error,
          message: StateMessage.error(
            messageHandler: ResponseMessage(
              message: ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
        ),
      );
    }
  }

  Future<void> _onSessionRequest(SessionRequestEvent? args) async {
    if (args != null) {
      for (final evm in BlockchainType.values) {
        if (evm == BlockchainType.tezos) continue;

        if (args.chainId == evm.chain) {
          log.i('[WALLET] _onSessionRequest $args');
          final handler = sessionRequestHandlers[args.method];
          if (handler != null) {
            await handler(args.topic, args.params);
          }
        }
      }
    }
  }

  void _onSessionConnect(SessionConnect? args) {
    if (args != null) {
      log.i(args);
      //sessions.value.add(args.session);

      final savedDappData = SavedDappData(
        sessionData: args.session,
      );

      log.i(savedDappData.toJson());
      connectedDappRepository.insert(savedDappData);
    }
  }

  void _onPairingCreate(PairingEvent? args) {
    log.i('Pairing Create Event: $args');
  }

  Future<void> _onAuthRequest(SessionAuthRequest? args) async {
    if (args != null) {
      log.i(args);
      // List<ChainKey> chainKeys = GetIt.I<IKeyService>().getKeysForChain(
      //   'eip155:1',
      // );
      // Create the message to be signed
      //final String iss = 'did:pkh:eip155:1:${chainKeys.first.publicKey}';

      // print(args);
      //   final Widget w = WCRequestWidget(
      //     child: WCConnectionRequestWidget(
      //       wallet: _reownWalletKit!,
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
      //     final String message = _reownWalletKit!.formatAuthMessage(
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

      //     await _reownWalletKit!.respondAuthRequest(
      //       id: args.id,
      //       iss: iss,
      //       signature: CacaoSignature(
      //         t: CacaoSignature.EIP191,
      //         s: sig,
      //       ),
      //     );
      //   } else {
      //     await _reownWalletKit!.respondAuthRequest(
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
    final completer = Completer<String>();
    double counter = 0;
    Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      counter = counter + 0.5;
      log.i('counter: $counter');
      final String currenRouteName = routeCubit.state ?? '';

      if (currenRouteName != CONFIRM_CONNECTION_PAGE) {
        timer.cancel();
        final result = await personalSignAction(topic, parameters);
        completer.complete(result);
      }
    });
    return completer.future;
  }

  Future<String> personalSignAction(String topic, dynamic parameters) async {
    log.i('received personal sign request: $parameters');
    log.i('topic: $topic');

    log.i('completer initialise');
    completer.add(Completer<String>());

    final pRequest = _reownWalletKit!.pendingRequests.getAll().last;
    var response = JsonRpcResponse(id: pRequest.id, jsonrpc: '2.0');

    emit(
      state.copyWith(
        status: WalletConnectStatus.signPayload,
        parameters: parameters,
        sessionTopic: topic,
        signType: Parameters.PERSONAL_SIGN,
      ),
    );

    final String result = await completer[completer.length - 1]!.future;
    log.i('complete - $result');

    if (result == 'Failed') {
      response = response.copyWith(
        error: const JsonRpcError(code: 5001, message: 'User rejected method'),
      );
    } else {
      response = response.copyWith(result: result);
    }

    await _reownWalletKit!.respondSessionRequest(
      topic: topic,
      response: response,
    );

    completer.removeLast();
    return result;
  }

  Future<String> ethSign(String topic, dynamic parameters) async {
    log.i('received eth sign request: $parameters');

    log.i('completer initialise');
    completer.add(Completer<String>());

    final pRequest = _reownWalletKit!.pendingRequests.getAll().last;
    var response = JsonRpcResponse(id: pRequest.id, jsonrpc: '2.0');

    emit(
      state.copyWith(
        status: WalletConnectStatus.signPayload,
        parameters: parameters,
        sessionTopic: topic,
        signType: Parameters.ETH_SIGN,
      ),
    );

    final String result = await completer[completer.length - 1]!.future;
    log.i('complete - $result');

    if (result == 'Failed') {
      response = response.copyWith(
        error: const JsonRpcError(code: 5001, message: 'User rejected method'),
      );
    } else {
      response = response.copyWith(result: result);
    }

    await _reownWalletKit!.respondSessionRequest(
      topic: topic,
      response: response,
    );

    completer.removeLast();
    return result;
  }

  Future<String> ethSignTransaction(String topic, dynamic parameters) async {
    log.i('received eth sign transaction request: $parameters');

    log.i('completer initialise');
    completer.add(Completer<String>());

    final pRequest = _reownWalletKit!.pendingRequests.getAll().last;
    var response = JsonRpcResponse(id: pRequest.id, jsonrpc: '2.0');
    final transaction = getTransaction(parameters);

    emit(
      state.copyWith(
        status: WalletConnectStatus.signPayload,
        parameters: parameters,
        sessionTopic: topic,
        signType: Parameters.ETH_SIGN_TRANSACTION,
        transaction: transaction,
      ),
    );

    final String result = await completer[completer.length - 1]!.future;
    log.i('complete - $result');

    if (result == 'Failed') {
      response = response.copyWith(
        error: const JsonRpcError(code: 5001, message: 'User rejected method'),
      );
    } else {
      response = response.copyWith(result: result);
    }

    await _reownWalletKit!.respondSessionRequest(
      topic: topic,
      response: response,
    );

    completer.removeLast();
    return result;
  }

  Future<String> ethSendTransaction(String topic, dynamic parameters) async {
    log.i('received eth send transaction request: $parameters');

    log.i('completer initialise');
    completer.add(Completer<String>());

    final pRequest = _reownWalletKit!.pendingRequests.getAll().last;
    var response = JsonRpcResponse(id: pRequest.id, jsonrpc: '2.0');

    final Transaction transaction = getTransaction(parameters);

    emit(
      state.copyWith(
        status: WalletConnectStatus.operation,
        parameters: parameters,
        sessionTopic: topic,
        signType: Parameters.ETH_SIGN_TRANSACTION,
        transaction: transaction,
      ),
    );

    final String result = await completer[completer.length - 1]!.future;
    log.i('complete - $result');

    if (result == 'Failed') {
      response = response.copyWith(
        error: const JsonRpcError(code: 5001, message: 'User rejected method'),
      );
    } else {
      response = response.copyWith(result: result);
    }

    await _reownWalletKit!.respondSessionRequest(
      topic: topic,
      response: response,
    );
    completer.removeLast();
    return result;
  }

  Future<String> ethSignTypedData(String topic, dynamic parameters) async {
    log.i('received eth sign typed data request: $parameters');

    log.i('completer initialise');
    completer.add(Completer<String>());

    final pRequest = _reownWalletKit!.pendingRequests.getAll().last;
    var response = JsonRpcResponse(id: pRequest.id, jsonrpc: '2.0');

    emit(
      state.copyWith(
        status: WalletConnectStatus.signPayload,
        parameters: parameters,
        sessionTopic: topic,
        signType: Parameters.ETH_SIGN_TYPE_DATA,
      ),
    );

    final String result = await completer[completer.length - 1]!.future;
    log.i('complete - $result');

    if (result == 'Failed') {
      response = response.copyWith(
        error: const JsonRpcError(code: 5001, message: 'User rejected method'),
      );
    } else {
      response = response.copyWith(result: result);
    }

    await _reownWalletKit!.respondSessionRequest(
      topic: topic,
      response: response,
    );

    completer.removeLast();
    return result;
  }

  Future<String> ethSignTypedDataV4(String topic, dynamic parameters) async {
    log.i('received eth sign typed data request: $parameters');

    log.i('completer initialise');
    completer.add(Completer<String>());

    final pRequest = _reownWalletKit!.pendingRequests.getAll().last;
    var response = JsonRpcResponse(id: pRequest.id, jsonrpc: '2.0');

    emit(
      state.copyWith(
        status: WalletConnectStatus.signPayload,
        parameters: parameters,
        sessionTopic: topic,
        signType: Parameters.ETH_SIGN_TYPE_DATA_V4,
      ),
    );

    final String result = await completer[completer.length - 1]!.future;
    log.i('complete - $result');

    if (result == 'Failed') {
      response = response.copyWith(
        error: const JsonRpcError(code: 5001, message: 'User rejected method'),
      );
    } else {
      response = response.copyWith(result: result);
    }

    await _reownWalletKit!.respondSessionRequest(
      topic: topic,
      response: response,
    );

    completer.removeLast();
    return result;
  }

  Future<String> tezosGetAccounts(String topic, dynamic parameters) async {
    log.i('tezosGetAccounts topic: $topic');
    log.i('tezosGetAccounts parameters: $parameters');

    final currentAccount = walletCubit.state.currentAccount!;

    final pRequest = _reownWalletKit!.pendingRequests.getAll().last;
    var response = JsonRpcResponse(
      id: pRequest.id,
      jsonrpc: '2.0',
    );

    final isTezos = currentAccount.blockchainType == BlockchainType.tezos;

    if (isTezos) {
      final pubkey = await KeyGenerator().hexPubKey(
        secretKey: currentAccount.secretKey,
        accountType: AccountType.tezos,
      );

      response = response.copyWith(
        result: [
          {
            'algo': 'ed25519',
            'pubkey': pubkey,
            'address': currentAccount.walletAddress,
          }
        ],
      );
    } else {
      response = response.copyWith(
        error: const JsonRpcError(code: 5001, message: 'Wrong blockchain'),
      );
    }

    await _reownWalletKit!.respondSessionRequest(
      topic: topic,
      response: response,
    );

    return 'true';
  }

  Future<String> tezosSign(String topic, dynamic parameters) async {
    log.i('tezosSign topic: $topic');

    log.i('received tezos sign request: $parameters');

    log.i('completer initialise');
    completer.add(Completer<String>());

    final pRequest = _reownWalletKit!.pendingRequests.getAll().last;
    var response = JsonRpcResponse(id: pRequest.id, jsonrpc: '2.0');

    emit(
      state.copyWith(
        status: WalletConnectStatus.signPayload,
        parameters: parameters,
        sessionTopic: topic,
        signType: Parameters.TEZOS_SIGN,
      ),
    );

    final String result = await completer[completer.length - 1]!.future;
    log.i('complete - $result');

    if (result == 'Failed') {
      response = response.copyWith(
        error: const JsonRpcError(code: 5001, message: 'User rejected method'),
      );
    } else {
      response = response.copyWith(
        result: {'signature': result},
      );
    }

    await _reownWalletKit!.respondSessionRequest(
      topic: topic,
      response: response,
    );

    completer.removeLast();
    emit(state.copyWith(status: WalletConnectStatus.idle));
    return result;
  }

  Future<String> tezosSend(String topic, dynamic parameters) async {
    log.i('tezosSend topic: $topic');
    log.i('tezosSend parameters: $parameters');

    log.i('completer initialise');
    completer.add(Completer<String>());

    final pRequest = _reownWalletKit!.pendingRequests.getAll().last;
    var response = JsonRpcResponse(id: pRequest.id, jsonrpc: '2.0');

    final operationDetails = getTezosOperationDetails(
      parameters as Map<String, dynamic>,
    );

    emit(
      state.copyWith(
        status: WalletConnectStatus.operation,
        parameters: parameters,
        sessionTopic: topic,
        signType: Parameters.TEZOS_SEND,
        operationDetails: operationDetails,
      ),
    );

    final String result = await completer[completer.length - 1]!.future;
    log.i('complete - $result');

    if (result == 'Failed') {
      response = response.copyWith(
        error: const JsonRpcError(code: 5001, message: 'User rejected method'),
      );
    } else {
      response = response.copyWith(result: {'operationHash': result});
    }

    await _reownWalletKit!.respondSessionRequest(
      topic: topic,
      response: response,
    );
    completer.removeLast();
    return result;
  }

  Transaction getTransaction(dynamic parameters) {
    final EthereumTransaction ethTransaction = EthereumTransaction.fromJson(
      parameters[0] as Map<String, dynamic>,
    );

    final from = EthereumAddress.fromHex(ethTransaction.from);
    final to = EthereumAddress.fromHex(ethTransaction.to);
    final value = EtherAmount.fromBigInt(
      EtherUnit.wei,
      ethTransaction.value != null
          ? BigInt.tryParse(ethTransaction.value!) ?? BigInt.zero
          : BigInt.zero,
    );
    // final gasPrice = ethTransaction.gasPrice != null
    //     ? EtherAmount.fromBigInt(
    //         EtherUnit.gwei,
    //         BigInt.tryParse(ethTransaction.gasPrice!) ?? BigInt.zero,
    //       )
    //     : null;
    // final maxFeePerGas = ethTransaction.maxFeePerGas != null
    //     ? EtherAmount.fromBigInt(
    //         EtherUnit.gwei,
    //         BigInt.tryParse(ethTransaction.maxFeePerGas!) ?? BigInt.zero,
    //       )
    //     : null;
    // final maxPriorityFeePerGas = ethTransaction.maxPriorityFeePerGas != null
    //     ? EtherAmount.fromBigInt(
    //         EtherUnit.gwei,
    //         BigInt.tryParse(ethTransaction.maxPriorityFeePerGas!) ??
    //             BigInt.zero,
    //       )
    //     : null;
    // final maxGas = int.tryParse(ethTransaction.gasLimit ?? '');
    // final nonce = int.tryParse(ethTransaction.nonce ?? '');
    final data = (ethTransaction.data != null && ethTransaction.data != '0x')
        ? Uint8List.fromList(utf8.encode(ethTransaction.data!))
        : null;

    // Construct a transaction from the EthereumTransaction object
    final transaction = Transaction(
      from: from,
      to: to,
      value: value,
      // gasPrice: gasPrice,
      // maxFeePerGas: maxFeePerGas,
      // maxPriorityFeePerGas: maxPriorityFeePerGas,
      // maxGas: maxGas,
      // nonce: nonce,
      data: data,
    );

    return transaction;
  }

  List<OperationDetails> getTezosOperationDetails(
    Map<String, dynamic> parameters,
  ) {
    final from = parameters['account'];
    final operations = parameters['operations'] as List<dynamic>;

    final operationDetails = <OperationDetails>[];
    for (final op in operations) {
      final operationDetail = OperationDetails(
        source: from.toString(),
        amount: op['amount'].toString(),
        destination: op['destination'].toString(),
        kind: stringToEnum(op['kind'].toString()),
        parameters: op['parameters'],
      );
      operationDetails.add(operationDetail);
    }

    return operationDetails;
  }

  OperationKind stringToEnum(String operation) {
    return OperationKind.values.firstWhere(
      (e) => e.toString().split('.').last == operation,
      orElse: () => OperationKind.transaction,
    );
  }

  Future<void> disconnectSession(String topic) async {
    log.i('disconnectSession: $topic');
    await _reownWalletKit!.disconnectSession(
      topic: topic,
      reason: Errors.getSdkError(Errors.USER_DISCONNECTED).toSignError(),
    );
  }

  Future<void> dispose() async {
    log.i('web3wallet dispose');
    _reownWalletKit!.core.pairing.onPairingInvalid
        .unsubscribe(_onPairingInvalid);
    _reownWalletKit!.pairings.onSync.unsubscribe(_onPairingsSync);
    _reownWalletKit!.onSessionProposal.unsubscribe(_onSessionProposal);
    _reownWalletKit!.onSessionProposalError
        .unsubscribe(_onSessionProposalError);
    _reownWalletKit!.onSessionConnect.unsubscribe(_onSessionConnect);
    _reownWalletKit!.onSessionRequest.unsubscribe(_onSessionRequest);
    _reownWalletKit!.onSessionAuthRequest.unsubscribe(_onAuthRequest);
  }
}
