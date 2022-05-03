part of 'choose_wallet_type_cubit.dart';

@JsonSerializable()
class ChooseWalletTypeState extends Equatable {
  const ChooseWalletTypeState({this.selectedWallet = WalletType.personal});

  factory ChooseWalletTypeState.fromJson(Map<String, dynamic> json) =>
      _$ChooseWalletTypeStateFromJson(json);

  final WalletType selectedWallet;

  ChooseWalletTypeState copyWith({WalletType? selectedWallet}) {
    return ChooseWalletTypeState(
      selectedWallet: selectedWallet ?? this.selectedWallet,
    );
  }

  Map<String, dynamic> toJson() => _$ChooseWalletTypeStateToJson(this);

  @override
  List<Object?> get props => [selectedWallet];
}
