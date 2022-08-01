import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_select_box_cubit.g.dart';

part 'account_select_box_state.dart';

class AccountSelectBoxCubit extends Cubit<AccountSelectBoxState> {
  AccountSelectBoxCubit({
    required this.walletCubit,
  }) : super(
          AccountSelectBoxState(
            selectedAccountIndex: walletCubit.state.currentCryptoIndex,
            accounts: walletCubit.state.cryptoAccount.data,
          ),
        );

  final WalletCubit walletCubit;

  void setSelectedAccount(int index) {
    emit(state.copyWith(selectedAccountIndex: index));
  }

  void toggleSelectBox() {
    emit(state.copyWith(isBoxOpen: !state.isBoxOpen));
  }
}
