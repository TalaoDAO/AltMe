part of 'send_to_cubit.dart';

@JsonSerializable()
class SendToState extends Equatable {
  const SendToState({
    this.withdrawalAddress = '',
  });

  factory SendToState.fromJson(Map<String, dynamic> json) =>
      _$SendToStateFromJson(json);

  final String withdrawalAddress;

  SendToState copyWith({
    String? withdrawalAddress,
    CryptoAccountData? selectedAccount,
    bool? isOtherAccountTab,
  }) {
    return SendToState(
      withdrawalAddress: withdrawalAddress ?? this.withdrawalAddress,
    );
  }

  Map<String, dynamic> toJson() => _$SendToStateToJson(this);

  @override
  List<Object?> get props => [
        withdrawalAddress,
      ];
}
