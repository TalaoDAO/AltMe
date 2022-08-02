import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_select_box_cubit.g.dart';

part 'account_select_box_state.dart';

class AccountSelectBoxCubit extends Cubit<AccountSelectBoxState> {
  AccountSelectBoxCubit({
    required List<CryptoAccountData> accounts,
    required int selectedAccountIndex,
  }) : super(
          AccountSelectBoxState(
            selectedAccountIndex: selectedAccountIndex,
            accounts: accounts,
          ),
        );

  void setAccounts(List<CryptoAccountData> accounts) {
    emit(state.copyWith(accounts: accounts));
  }

  void setSelectedAccount(int index) {
    emit(state.copyWith(selectedAccountIndex: index));
  }

  void toggleSelectBox() {
    emit(state.copyWith(isBoxOpen: !state.isBoxOpen));
  }
}
