import 'package:altme/app/app.dart';
import 'package:http/http.dart' as http;
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

  static Future<BigInt> estimateEthereumFee({
    required String web3RpcURL,
    required EthereumAddress sender,
    required EthereumAddress reciever,
    required EtherAmount amount,
    String? data,
  }) async {
    log.i('estimateEthereumFee');
    final Web3Client web3Client = Web3Client(web3RpcURL, http.Client());
    final gasPrice = await web3Client.getGasPrice();

    log.i('from: ${sender.hex}');
    log.i('to: ${reciever.hex}');
    log.i('gasPrice: ${gasPrice.getInWei}');
    log.i('value: ${amount.getInWei}');
    log.i('data: $data');

    try {
      final BigInt gas = await web3Client.estimateGas(
        sender: sender,
        to: reciever,
        value: amount,
        gasPrice: gasPrice,
        data: data != null ? hexToBytes(data) : null,
      );
      log.i('gas - $gas');

      final fee = gas * gasPrice.getInWei;
      log.i('gas * gasPrice.getInWei = $fee');
      return fee;
    } catch (e) {
      log.e(e.toString());
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
