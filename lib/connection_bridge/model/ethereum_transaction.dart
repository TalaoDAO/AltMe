import 'package:json_annotation/json_annotation.dart';

part 'ethereum_transaction.g.dart';

@JsonSerializable(includeIfNull: false)
class EthereumTransaction {
  EthereumTransaction({
    required this.from,
    required this.to,
    this.value,
    this.nonce,
    this.gasPrice,
    this.maxFeePerGas,
    this.maxPriorityFeePerGas,
    this.gas,
    this.gasLimit,
    this.data,
  });

  factory EthereumTransaction.fromJson(Map<String, dynamic> json) =>
      _$EthereumTransactionFromJson(json);
  final String from;
  final String to;
  final String? value;
  final String? nonce;
  final String? gasPrice;
  final String? maxFeePerGas;
  final String? maxPriorityFeePerGas;
  final String? gas;
  final String? gasLimit;
  final String? data;

  Map<String, dynamic> toJson() => _$EthereumTransactionToJson(this);

  @override
  String toString() {
    return 'WCEthereumTransaction(from: $from, to: $to, nonce: $nonce,'
        ' gasPrice: $gasPrice, maxFeePerGas: $maxFeePerGas, maxPriorityFeePerGas: '
        '$maxPriorityFeePerGas, gas: $gas, gasLimit: $gasLimit,'
        ' value: $value, data: $data)';
  }
}
