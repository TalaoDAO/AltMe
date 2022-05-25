part of 'wallet_cubit.dart';

@JsonSerializable()
class WalletState extends Equatable {
  WalletState({
    this.status = WalletStatus.init,
    this.message,
    List<CredentialModel>? credentials,
  }) : credentials = credentials ?? [];

  factory WalletState.fromJson(Map<String, dynamic> json) =>
      _$WalletStateFromJson(json);

  final WalletStatus status;
  final List<CredentialModel> credentials;
  final StateMessage? message;

  WalletState loading() {
    return WalletState(status: WalletStatus.loading, credentials: credentials);
  }

  WalletState error({required MessageHandler messageHandler}) {
    return WalletState(
      status: WalletStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      credentials: credentials,
    );
  }

  WalletState success({
    required WalletStatus status,
    MessageHandler? messageHandler,
    List<CredentialModel>? credentials,
  }) {
    return WalletState(
      status: status,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      credentials: credentials ?? this.credentials,
    );
  }

  Map<String, dynamic> toJson() => _$WalletStateToJson(this);

  @override
  List<Object?> get props => [status, message, credentials];

  WalletState copyWith({
    WalletStatus? status,
    List<CredentialModel>? credentials,
  }) {
    return WalletState(
      status: status ?? this.status,
      credentials: credentials ?? this.credentials,
    );
  }
}
