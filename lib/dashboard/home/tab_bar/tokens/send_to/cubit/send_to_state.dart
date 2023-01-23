part of 'send_to_cubit.dart';

@JsonSerializable()
class SendToState extends Equatable {
  const SendToState({
    this.withdrawalAddress = '',
    this.isOtherAccountTab = true,
  });

  factory SendToState.fromJson(Map<String, dynamic> json) =>
      _$SendToStateFromJson(json);

  final String withdrawalAddress;
  final bool isOtherAccountTab;

  SendToState copyWith({
    String? withdrawalAddress,
    CryptoAccountData? selectedAccount,
    bool? isOtherAccountTab,
  }) {
    return SendToState(
      withdrawalAddress: withdrawalAddress ?? this.withdrawalAddress,
      isOtherAccountTab: isOtherAccountTab ?? this.isOtherAccountTab,
    );
  }

  Map<String, dynamic> toJson() => _$SendToStateToJson(this);

  @override
  List<Object?> get props => [
        withdrawalAddress,
        isOtherAccountTab,
      ];
}
