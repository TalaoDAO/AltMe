part of 'crypto_bottom_sheet_cubit.dart';

@JsonSerializable()
class CryptoBottomSheetState extends Equatable {
  const CryptoBottomSheetState({
    this.status = AppStatus.init,
    this.message,
  });

  factory CryptoBottomSheetState.fromJson(Map<String, dynamic> json) =>
      _$CryptoBottomSheetStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;

  CryptoBottomSheetState loading() {
    return const CryptoBottomSheetState(
      status: AppStatus.loading,
    );
  }

  CryptoBottomSheetState error({required MessageHandler messageHandler}) {
    return CryptoBottomSheetState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  CryptoBottomSheetState success({MessageHandler? messageHandler}) {
    return CryptoBottomSheetState(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
  }

  Map<String, dynamic> toJson() => _$CryptoBottomSheetStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        message,
      ];
}
