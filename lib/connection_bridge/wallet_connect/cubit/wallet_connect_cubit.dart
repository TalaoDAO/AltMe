import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/route/route.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:web3dart/web3dart.dart';

part 'wallet_connect_cubit.g.dart';
part 'wallet_connect_state.dart';

class WalletConnectCubit extends Cubit<WalletConnectState> {
  WalletConnectCubit(
      {required this.connectedDappRepository,
      required this.secureStorageProvider,
      required this.routeCubit})
      : super(const WalletConnectState()) {
    initialise();
  }

  final ConnectedDappRepository connectedDappRepository;
  final SecureStorageProvider secureStorageProvider;
  final RouteCubit routeCubit;

  final log = getLogger('WalletConnectCubit');

  Web3Wallet? _web3Wallet;

  Web3Wallet? get web3Wallet => _web3Wallet;

  Future<void> initialise() async {
    try {
      _web3Wallet = null;

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

        log.i('registering acconts');
        for (final evm in eVMAccounts) {
          _web3Wallet!.registerAccount(
            chainId: evm.blockchainType.chain,
            accountAddress: evm.walletAddress,
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

      /// register request emitter and request handler for all supported evms

      for (final blockchainType in BlockchainType.values) {
        if (blockchainType == BlockchainType.tezos) {
          continue;
        }
        log.i(blockchainType);
        log.i('registerEventEmitter');
        registerEventEmitter(blockchainType.chain);

        log.i('registerRequestHandler');
        registerRequestHandler(blockchainType.chain);
      }

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

  void registerEventEmitter(String chain) {
    for (final String event in Parameters.walletConnectEvents) {
      _web3Wallet!.registerEventEmitter(
        chainId: chain,
        event: event,
      );
    }
  }

  void registerRequestHandler(String chain) {
    _web3Wallet!.registerRequestHandler(
      chainId: chain,
      method: Parameters.PERSONAL_SIGN,
      handler: personalSign,
    );
    _web3Wallet!.registerRequestHandler(
      chainId: chain,
      method: Parameters.ETH_SIGN,
      handler: ethSign,
    );
    _web3Wallet!.registerRequestHandler(
      chainId: chain,
      method: Parameters.ETH_SIGN_TRANSACTION,
      handler: ethSignTransaction,
    );
    _web3Wallet!.registerRequestHandler(
      chainId: chain,
      method: Parameters.ETH_SIGN_TYPE_DATA,
      handler: ethSignTypedData,
    );
    _web3Wallet!.registerRequestHandler(
      chainId: chain,
      method: Parameters.ETH_SIGN_TYPE_DATA_V4,
      handler: ethSignTypedDataV4,
    );
    _web3Wallet!.registerRequestHandler(
      chainId: chain,
      method: Parameters.ETH_SEND_TRANSACTION,
      handler: ethSendTransaction,
    );
  }

  Future<void> connect(String walletConnectUri) async {
    log.i('walletConnectUri - $walletConnectUri');

    final Uri uriData = Uri.parse(walletConnectUri);
    final PairingInfo pairingInfo = await _web3Wallet!.pair(
      uri: uriData,
    );
    log.i(pairingInfo);
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

  Future<void> _onAuthRequest(AuthRequest? args) async {
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
        sessionTopic: topic,
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
        sessionTopic: topic,
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
    completer.removeLast();
    return result;
  }

  Future<String> ethSignTypedData(String topic, dynamic parameters) async {
    log.i('received eth sign typed data request: $parameters');

    log.i('completer initialise');
    completer.add(Completer<String>());

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
    completer.removeLast();
    return result;
  }

  Future<String> ethSignTypedDataV4(String topic, dynamic parameters) async {
    log.i('received eth sign typed data request: $parameters');

    log.i('completer initialise');
    completer.add(Completer<String>());

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
