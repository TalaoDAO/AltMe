part of 'account_select_box_cubit.dart';

@JsonSerializable()
class AccountSelectBoxState extends Equatable {
  const AccountSelectBoxState({
    this.selectedAccountIndex = 0,
    this.isBoxOpen = false,
    this.accounts = const [],
  });

  factory AccountSelectBoxState.fromJson(Map<String, dynamic> json) =>
      _$AccountSelectBoxStateFromJson(json);

  final int selectedAccountIndex;
  final bool isBoxOpen;
  final List<CryptoAccountData> accounts;

  AccountSelectBoxState copyWith({
    int? selectedAccountIndex,
    bool? isBoxOpen,
    List<CryptoAccountData>? accounts,
  }) {
    return AccountSelectBoxState(
      selectedAccountIndex: selectedAccountIndex ?? this.selectedAccountIndex,
      accounts: accounts ?? this.accounts,
      isBoxOpen: isBoxOpen ?? this.isBoxOpen,
    );
  }

  Map<String, dynamic> toJson() => _$AccountSelectBoxStateToJson(this);

  @override
  List<Object?> get props => [accounts, selectedAccountIndex, isBoxOpen];
}
