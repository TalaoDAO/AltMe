part of 'wallet_cubit.dart';

enum WalletStatus { init, idle, insert, delete, update, reset }

@JsonSerializable()
class WalletState extends Equatable {
  WalletState({
    this.status = WalletStatus.init,
    List<CredentialModel>? credentials,
  }) : credentials = credentials ?? [];

  factory WalletState.fromJson(Map<String, dynamic> json) =>
      _$WalletStateFromJson(json);

  final WalletStatus status;
  final List<CredentialModel> credentials;

  WalletState copyWith({
    WalletStatus? status,
    List<CredentialModel>? credentials,
  }) {
    return WalletState(
      status: status ?? this.status,
      credentials: credentials ?? this.credentials,
    );
  }

  Map<String, dynamic> toJson() => _$WalletStateToJson(this);

  @override
  List<Object?> get props => [status, credentials];
}
