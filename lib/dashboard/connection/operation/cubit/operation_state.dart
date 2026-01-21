part of 'operation_cubit.dart';

@JsonSerializable()
class OperationState extends Equatable {
  const OperationState({
    this.status = AppStatus.init,
    this.message,
    this.amount = '0',
    this.totalFee = '0',
    this.bakerFee,
    this.usdRate = 0,
    this.cryptoAccountData,
    this.dAppName = '',
  });

  factory OperationState.fromJson(Map<String, dynamic> json) =>
      _$OperationStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final String amount;
  final String totalFee;
  final String? bakerFee;
  final double usdRate;
  final CryptoAccountData? cryptoAccountData;
  final String dAppName;

  OperationState loading() {
    return copyWith(status: AppStatus.loading);
  }

  OperationState error({required MessageHandler messageHandler}) {
    return copyWith(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  OperationState copyWith({
    AppStatus? status,
    StateMessage? message,
    String? amount,
    String? totalFee,
    String? bakerFee,
    double? usdRate,
    int? selectedIndex,
    CryptoAccountData? cryptoAccountData,
    String? dAppName,
  }) {
    return OperationState(
      status: status ?? this.status,
      message: message,
      amount: amount ?? this.amount,
      totalFee: totalFee ?? this.totalFee,
      bakerFee: bakerFee,
      usdRate: usdRate ?? this.usdRate,
      cryptoAccountData: cryptoAccountData ?? this.cryptoAccountData,
      dAppName: dAppName ?? this.dAppName,
    );
  }

  Map<String, dynamic> toJson() => _$OperationStateToJson(this);

  @override
  List<Object?> get props => [
    status,
    message,
    amount,
    totalFee,
    bakerFee,
    usdRate,
    cryptoAccountData,
    dAppName,
  ];
}
