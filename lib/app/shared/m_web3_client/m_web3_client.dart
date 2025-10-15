import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class MWeb3Client {
  static final log = getLogger('MWeb3Client');

  static Future<double> getEVMBalance({
    required String secretKey,
    required String rpcUrl,
  }) async {
    final httpClient = Client();
    final ethClient = Web3Client(rpcUrl, httpClient);

    final credentials = EthPrivateKey.fromHex(secretKey);

    final balance = await ethClient.getBalance(credentials.address);
    final balanceInUnit = balance.getValueInUnit(EtherUnit.ether);
    log.i('ETH balance in unit: $balanceInUnit');
    return balanceInUnit;
  }

  static Future<void> burnToken({
    required String privateKey,
    required String rpcUrl,
    required String contractAddress,
    required String abi,
    required BigInt tokenId,
    required int chainId,
  }) async {
    final httpClient = Client();
    final client = Web3Client(rpcUrl, httpClient);

    final credentials = EthPrivateKey.fromHex(privateKey);

    final nftContract = DeployedContract(
      ContractAbi.fromJson(abi, 'NFT'),
      EthereumAddress.fromHex(contractAddress),
    );

    final function = nftContract.function('burn');
    final params = [tokenId];

    final transaction = Transaction.callContract(
      contract: nftContract,
      function: function,
      parameters: params,
    );

    await client.signTransaction(credentials, transaction, chainId: chainId);

    final result = await client.sendTransaction(
      credentials,
      transaction,
      chainId: chainId,
    );
    log.i('Transaction sent: $result');
  }

  static double formatEthAmount({
    required BigInt amount,
    EtherUnit fromUnit = EtherUnit.wei,
    EtherUnit toUnit = EtherUnit.ether,
  }) {
    if (amount == BigInt.zero) return 0;

    final String ethAmount = EtherAmount.fromBigInt(
      fromUnit,
      amount,
    ).getValueInUnit(toUnit).toStringAsFixed(6).characters.take(7).toString();

    return double.parse(ethAmount);
  }

  static Future<String?> sendToken({
    required String selectedAccountSecretKey,
    required String rpcUrl,
    required TokenModel token,
    required String withdrawalAddress,
    required double amountInWei,
    required int chainId,
  }) async {
    try {
      final client = Web3Client(rpcUrl, Client());
      final gasPrice = await client.getGasPrice();
      final credentials = EthPrivateKey.fromHex(selectedAccountSecretKey);
      final sender = credentials.address;
      final EthereumAddress receiver = EthereumAddress.fromHex(
        withdrawalAddress,
      );

      // read the contract abi and tell web3dart where
      // it's deployed (contractAddr)

      late DeployedContract contract;
      //late ContractEvent transferEvent;
      late ContractFunction balanceFunction;
      late ContractFunction sendFunction;
      late List<dynamic> balanceFunctionParams;
      late List<dynamic> sendTransactionFunctionParams;

      if (token.standard?.toLowerCase() == 'erc20') {
        final abiCode = await rootBundle.loadString(
          'assets/abi/erc20.abi.json',
        );
        final contractAddress = EthereumAddress.fromHex(token.contractAddress);
        contract = DeployedContract(
          ContractAbi.fromJson(abiCode, 'ERC20'),
          contractAddress,
        );

        // extracting some functions and events that we'll need later
        //transferEvent = contract.event('Transfer');
        balanceFunction = contract.function('balanceOf');
        sendFunction = contract.function('transfer');

        balanceFunctionParams = <dynamic>[sender];
        sendTransactionFunctionParams = <dynamic>[
          receiver,
          BigInt.from(amountInWei),
        ];
      } else if (token.standard?.toLowerCase() == 'erc721') {
        final abiCode = await rootBundle.loadString(
          'assets/abi/erc721.abi.json',
        );
        final contractAddress = EthereumAddress.fromHex(token.contractAddress);
        contract = DeployedContract(
          ContractAbi.fromJson(abiCode, 'ERC721'),
          contractAddress,
        );

        // extracting some functions and events that we'll need later
        //transferEvent = contract.event('Transfer');
        balanceFunction = contract.function('balanceOf');
        sendFunction = contract.function('safeTransferFrom');

        balanceFunctionParams = <dynamic>[
          sender, //owner
        ];

        sendTransactionFunctionParams = <dynamic>[
          sender, // from
          receiver, // to
          BigInt.parse(token.tokenId!), //token id
        ];
      } else {
        //ERC1155
        final abiCode = await rootBundle.loadString(
          'assets/abi/erc1155.abi.json',
        );
        final contractAddress = EthereumAddress.fromHex(token.contractAddress);
        contract = DeployedContract(
          ContractAbi.fromJson(abiCode, 'ERC1155'),
          contractAddress,
        );

        // extracting some functions and events that we'll need later
        //transferEvent = contract.event('TransferSingle');
        balanceFunction = contract.function('balanceOf');
        sendFunction = contract.function('safeTransferFrom');
        balanceFunctionParams = <dynamic>[sender, BigInt.parse(token.tokenId!)];

        final bytes = Uint8List.fromList([]);
        sendTransactionFunctionParams = <dynamic>[
          sender, // from
          receiver, // to
          BigInt.parse(token.tokenId!), //token id
          BigInt.from(amountInWei), //amount
          bytes, //bytes
        ];
        log.i('ERC1155 bytes : $bytes');
      }

      // // listen for the Transfer event when it's emitted by the contract above
      // final subscription = client
      //     .events(
      //       FilterOptions.events(contract: contract, event: transferEvent),
      //     )
      //     .take(1)
      //     .listen((event) {
      //   final decoded =
      //       transferEvent.decodeResults(event.topics ?? [], event.data ?? ''); // ignore: lines_longer_than_80_chars

      //   final from = decoded[0] as EthereumAddress;
      //   final to = decoded[1] as EthereumAddress;
      //   final value = decoded[2] as BigInt;

      //   log.i('decoded response: $decoded');
      //   log.i('$from sent $value ${token.name} to $to');
      // });

      try {
        // check our balance in MetaCoins by calling the appropriate function
        final balance = await client.call(
          contract: contract,
          function: balanceFunction,
          params: balanceFunctionParams,
        );
        log.i('We have ${balance.first} ${token.name}');
      } catch (e, s) {
        log.e('error in the token balance e: $e, s: $s');
      }

      final txId = await client.sendTransaction(
        credentials,
        chainId: chainId,
        Transaction.callContract(
          contract: contract,
          function: sendFunction,
          gasPrice: gasPrice,
          parameters: sendTransactionFunctionParams,
        ),
      );

      // await subscription.asFuture<dynamic>();
      // await subscription.cancel();

      await client.dispose();
      return txId;
    } catch (e, s) {
      log.e('sendToken() error: $e , stack: $s');
      rethrow;
    }
  }

  // maxGas, gasPrice, feeData
  static Future<(BigInt, EtherAmount, BigInt)> estimateEVMFee({
    required String web3RpcURL,
    required EthereumAddress sender,
    required EthereumAddress reciever,
    required EtherAmount amount,
    String? data,
  }) async {
    log.i('estimateEthereumFee');
    final Web3Client web3Client = Web3Client(web3RpcURL, http.Client());
    final gasPrice = await web3Client.getGasPrice();
    try {
      log.i('from: ${sender.hex}');
      log.i('to: ${reciever.hex}');
      log.i('gasPrice: ${gasPrice.getInWei}');
      log.i('value: ${amount.getInWei}');
      log.i('data: $data');

      final BigInt maxGas = await web3Client.estimateGas(
        sender: sender,
        to: reciever,
        value: amount,
        gasPrice: gasPrice,
        data: data != null ? hexToBytes(data) : null,
      );
      log.i('maxGas - $maxGas');

      final fee = maxGas * gasPrice.getInWei;
      log.i('maxGas * gasPrice.getInWei = $fee');
      return (maxGas, gasPrice, fee);
    } catch (e, s) {
      log.e('e: $e, s: $s');
      final maxGas = BigInt.from(21000);
      final fee = maxGas * gasPrice.getInWei;
      log.i('maxGas - $maxGas');
      log.i('2100 * gasPrice.getInWei = $fee');
      return (maxGas, gasPrice, fee);
    }
  }

  static Future<String> sendEVMTransaction({
    required String web3RpcURL,
    required int chainId,
    required String privateKey,
    required EthereumAddress sender,
    required EthereumAddress receiver,
    required EtherAmount amount,
    BigInt? gas,
    EtherAmount? gasPrice,
    String? data,
  }) async {
    log.i('sendEthereumTransaction');
    final Web3Client web3Client = Web3Client(web3RpcURL, http.Client());
    final Credentials credentials = EthPrivateKey.fromHex(privateKey);

    final transaction = await getTransactionForEvmTransaction(
      web3Client: web3Client,
      sender: sender,
      receiver: receiver,
      amount: amount,
      gas: gas,
      gasPrice: gasPrice,
      data: data,
    );

    final transactionHash = await web3Client.sendTransaction(
      credentials,
      transaction,
      chainId: chainId,
    );

    log.i('chainId: $chainId');
    log.i('transactionHash - $transactionHash');
    return transactionHash;
  }

  static Future<Transaction> getTransactionForEvmTransaction({
    required Web3Client web3Client,
    required EthereumAddress sender,
    required EthereumAddress receiver,
    required EtherAmount amount,
    BigInt? gas,
    EtherAmount? gasPrice,
    String? data,
  }) async {
    final int nonce = await web3Client.getTransactionCount(sender);

    gasPrice ??= await web3Client.getGasPrice();

    gas ??= await web3Client.estimateGas(
      sender: sender,
      to: receiver,
      gasPrice: gasPrice,
      value: amount,
      data: data != null ? hexToBytes(data) : null,
    );

    final transaction = Transaction(
      from: sender,
      to: receiver,
      gasPrice: gasPrice,
      value: amount,
      data: data != null ? hexToBytes(data) : null,
      nonce: nonce,
      maxGas: gas.toInt(),
    );

    log.i('nonce: $nonce');
    log.i('maxGas: ${gas.toInt()}');
    log.i('gasPrice: $gasPrice');
    final fee = gas * gasPrice.getInWei;
    log.i('$gas * gasPrice.getInWei = $fee');

    return transaction;
  }

  static Future<Uint8List> getEvmTransactionSignature({
    required String web3RpcURL,
    required int chainId,
    required String privateKey,
    required EthereumAddress sender,
    required EthereumAddress receiver,
    required EtherAmount amount,
    BigInt? gas,
    EtherAmount? gasPrice,
    String? data,
  }) async {
    log.i('getEvmTransactionSignature');
    final Web3Client web3Client = Web3Client(web3RpcURL, http.Client());
    final Credentials credentials = EthPrivateKey.fromHex(privateKey);

    final transaction = await getTransactionForEvmTransaction(
      web3Client: web3Client,
      sender: sender,
      receiver: receiver,
      amount: amount,
      gas: gas,
      gasPrice: gasPrice,
      data: data,
    );

    // TODO(hawkbee): Ensure the account balance is big enough
    // final ethBalance = await MWeb3Client.getEVMBalance(
    //   rpcUrl: web3RpcURL,
    //   secretKey: privateKey,
    // );

    var signed = await web3Client.signTransaction(
      credentials,
      transaction,
      chainId: chainId,
      fetchChainIdFromNetworkId: false,
    );

    if (transaction.isEIP1559) {
      signed = prependTransactionType(0x02, signed);
    }

    return signed;
  }

  /// Currently used by OIDC4VP transaction flow because we need to get
  /// the hash sooner. We send the hash to the verifier to facilitate
  /// the payment validation.
  /// ATTENTION: This process won't work if a transaction is done on the account
  /// in the meanwhile because the signature may depends on the transaction
  /// count of the block.
  static Future<String> sendEVMTransactionWithSignature({
    required Uint8List signed,
    required String web3RpcURL,
  }) async {
    log.i('sendEVMTransactionWithSignature');
    final Web3Client web3Client = Web3Client(web3RpcURL, http.Client());

    return web3Client.sendRawTransaction(signed);
  }

  static String convertSignatureToStringHash(Uint8List signature) {
    // Hash the signed transaction using Keccak-256
    final Uint8List hash = keccak256(signature);

    // Convert to hexadecimal with 0x prefix
    final String transactionHash = bytesToHex(hash, include0x: true);

    return transactionHash;
  }
}
