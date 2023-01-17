import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class MWeb3Client {
  static final log = getLogger('MWeb3Client');

  static double formatEthAmount({
    required BigInt amount,
    EtherUnit fromUnit = EtherUnit.wei,
    EtherUnit toUnit = EtherUnit.ether,
  }) {
    if (amount == BigInt.zero) return 0;

    final String ethAmount = EtherAmount.fromUnitAndValue(fromUnit, amount)
        .getValueInUnit(toUnit)
        .toStringAsFixed(6)
        .characters
        .take(7)
        .toString();

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
      final sender = await credentials.extractAddress();

      // read the contract abi and tell web3dart where
      // it's deployed (contractAddr)
      final abiCode = await rootBundle.loadString('assets/abi/erc20.abi.json');
      final contractAddress = EthereumAddress.fromHex(token.contractAddress);
      final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'ERC20'),
        contractAddress,
      );

      // extracting some functions and events that we'll need later
      final transferEvent = contract.event('Transfer');
      final balanceFunction = contract.function('balanceOf');
      final sendFunction = contract.function('transfer');

      // listen for the Transfer event when it's emitted by the contract above
      final subscription = client
          .events(
            FilterOptions.events(contract: contract, event: transferEvent),
          )
          .take(1)
          .listen((event) {
        final decoded =
            transferEvent.decodeResults(event.topics ?? [], event.data ?? '');

        final from = decoded[0] as EthereumAddress;
        final to = decoded[1] as EthereumAddress;
        final value = decoded[2] as BigInt;

        log.i('decoded response: $decoded');
        log.i('$from sent $value ${token.name} to $to');
      });

      // check our balance in MetaCoins by calling the appropriate function
      final balance = await client.call(
        contract: contract,
        function: balanceFunction,
        params: <dynamic>[sender],
      );
      log.i('We have ${balance.first} ${token.name}');

      final EthereumAddress receiver =
          EthereumAddress.fromHex(withdrawalAddress);

      final txId = await client.sendTransaction(
        credentials,
        chainId: chainId,
        Transaction.callContract(
          contract: contract,
          function: sendFunction,
          gasPrice: gasPrice,
          parameters: <dynamic>[receiver, BigInt.from(amountInWei)],
        ),
      );

      await subscription.asFuture<dynamic>();
      await subscription.cancel();

      await client.dispose();
      return txId;
    } catch (e, s) {
      log.e('sendToken() error: $e , stack: $s');
      return null;
    }
  }

  static Future<BigInt> estimateEthereumFee({
    required String web3RpcURL,
    required EthereumAddress sender,
    required EthereumAddress reciever,
    required EtherAmount amount,
    String? data,
  }) async {
    log.i('estimateEthereumFee');
    late EtherAmount gasPrice = EtherAmount.inWei(BigInt.one);
    try {
      final Web3Client web3Client = Web3Client(web3RpcURL, http.Client());
      gasPrice = await web3Client.getGasPrice();

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
      return fee;
    } catch (e, s) {
      log.e('e: $e, s: $s');
      final fee = BigInt.from(21000) * gasPrice.getInWei;
      log.i('2100 * gasPrice.getInWei = $fee');
      return fee;
    }
  }

  static Future<String> sendEthereumTransaction({
    required String web3RpcURL,
    required int chainId,
    required String privateKey,
    required EthereumAddress sender,
    required EthereumAddress reciever,
    required EtherAmount amount,
    BigInt? gas,
    String? data,
  }) async {
    log.i('sendEthereumTransaction');
    final Web3Client web3Client = Web3Client(web3RpcURL, http.Client());
    final int nonce = await web3Client.getTransactionCount(sender);
    final EtherAmount gasPrice = await web3Client.getGasPrice();

    final maxGas = await web3Client.estimateGas(
      sender: sender,
      to: reciever,
      gasPrice: gasPrice,
      value: amount,
      data: data != null ? hexToBytes(data) : null,
    );

    final Credentials credentials = EthPrivateKey.fromHex(privateKey);

    final transaction = Transaction(
      from: sender,
      to: reciever,
      gasPrice: gasPrice,
      value: amount,
      data: data != null ? hexToBytes(data) : null,
      nonce: nonce,
      maxGas: maxGas.toInt(),
    );

    log.i('nonce: $nonce');
    log.i('maxGas: ${maxGas.toInt()}');
    log.i('chainId: $chainId');

    final transactionHash = await web3Client.sendTransaction(
      credentials,
      transaction,
      chainId: chainId,
    );

    log.i('transactionHash - $transactionHash');
    return transactionHash;
  }
}
