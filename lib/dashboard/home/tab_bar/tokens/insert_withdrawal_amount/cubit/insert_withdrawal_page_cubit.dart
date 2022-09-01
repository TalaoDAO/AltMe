import 'package:altme/app/logger/logger.dart';
import 'package:altme/dashboard/home/tab_bar/tokens/token_page/models/token_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'insert_withdrawal_page_state.dart';

part 'insert_withdrawal_page_cubit.g.dart';

class InsertWithdrawalPageCubit extends Cubit<InsertWithdrawalPageState> {
  InsertWithdrawalPageCubit({
    required this.defaultSelectedToken,
  }) : super(
          InsertWithdrawalPageState(
            selectedToken: defaultSelectedToken,
          ),
        );

  final TokenModel defaultSelectedToken;

  final log = getLogger('InsertWithdrawalPageCubit');

  void setAmount({required double amount}) {
    emit(
      state.copyWith(
        amount: amount,
        isValidWithdrawal: amount > 0 &&
            amount <= state.selectedToken.calculatedBalanceInDouble,
      ),
    );
  }

  void setSelectedToken({required TokenModel selectedToken}) {
    emit(
      state.copyWith(
        selectedToken: selectedToken,
        isValidWithdrawal: state.amount > 0 &&
            state.amount <= selectedToken.calculatedBalanceInDouble,
      ),
    );
  }
}
