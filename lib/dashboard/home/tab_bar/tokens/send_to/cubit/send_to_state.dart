part of 'send_to_cubit.dart';

@JsonSerializable()
class SendToState extends Equatable {
  const SendToState({
    this.withdrawalAddress = '',
    required this.selectedAccount,
  });

  factory SendToState.fromJson(Map<String, dynamic> json) =>
      _$SendToStateFromJson(json);

  final String withdrawalAddress;
  final CryptoAccountData selectedAccount;

  SendToState copyWith({
    String? withdrawalAddress,
    CryptoAccountData? selectedAccount,
  }) {
    return SendToState(
      withdrawalAddress: withdrawalAddress ?? this.withdrawalAddress,
      selectedAccount: selectedAccount ?? this.selectedAccount,
    );
  }

  Map<String, dynamic> toJson() => _$SendToStateToJson(this);

  @override
  List<Object?> get props => [withdrawalAddress, selectedAccount];
}
