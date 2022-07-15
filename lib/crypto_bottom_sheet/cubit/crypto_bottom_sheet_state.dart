part of 'crypto_bottom_sheet_cubit.dart';

@JsonSerializable()
class CryptoBottomSheetState extends Equatable {
  CryptoBottomSheetState({
    this.status = AppStatus.init,
    this.message,
    this.currentCryptoIndex = 0,
    CryptoAccount? cryptoAccount,
  }) : cryptoAccount = cryptoAccount ?? CryptoAccount(data: const []);

  factory CryptoBottomSheetState.fromJson(Map<String, dynamic> json) =>
      _$CryptoBottomSheetStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final int currentCryptoIndex;
  final CryptoAccount cryptoAccount;

  CryptoBottomSheetState loading() {
    return CryptoBottomSheetState(
      status: AppStatus.loading,
      currentCryptoIndex: currentCryptoIndex,
      cryptoAccount: cryptoAccount,
    );
  }

  CryptoBottomSheetState error({required MessageHandler messageHandler}) {
    return CryptoBottomSheetState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      currentCryptoIndex: currentCryptoIndex,
      cryptoAccount: cryptoAccount,
    );
  }

  CryptoBottomSheetState success({
    MessageHandler? messageHandler,
    CryptoAccount? cryptoAccount,
    int? currentCryptoIndex,
  }) {
    return CryptoBottomSheetState(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      currentCryptoIndex: currentCryptoIndex ?? this.currentCryptoIndex,
      cryptoAccount: cryptoAccount ?? this.cryptoAccount,
    );
  }

  Map<String, dynamic> toJson() => _$CryptoBottomSheetStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        message,
      ];
}
