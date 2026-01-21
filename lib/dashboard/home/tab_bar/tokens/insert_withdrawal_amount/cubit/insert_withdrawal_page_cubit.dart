import 'package:altme/app/logger/logger.dart';
import 'package:altme/dashboard/home/tab_bar/tokens/token_page/models/token_model.dart';
import 'package:bloc/bloc.dart';
import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'insert_withdrawal_page_state.dart';

part 'insert_withdrawal_page_cubit.g.dart';

class InsertWithdrawalPageCubit extends Cubit<InsertWithdrawalPageState> {
  InsertWithdrawalPageCubit({required this.defaultSelectedToken})
    : super(InsertWithdrawalPageState(selectedToken: defaultSelectedToken));

  final TokenModel defaultSelectedToken;

  final log = getLogger('InsertWithdrawalPageCubit');

  void setAmount({required String amount}) {
    emit(
      state.copyWith(
        amount: amount,
        isValidWithdrawal:
            double.parse(amount) > 0 &&
            Decimal.parse(amount) <=
                Decimal.parse(state.selectedToken.calculatedBalance),
      ),
    );
  }

  void setSelectedToken({required TokenModel selectedToken}) {
    emit(
      state.copyWith(
        selectedToken: selectedToken,
        isValidWithdrawal:
            double.parse(state.amount) > 0 &&
            Decimal.parse(state.amount) <=
                Decimal.parse(state.selectedToken.calculatedBalance),
      ),
    );
  }
}
