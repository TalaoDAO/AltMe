import 'package:altme/dashboard/dashboard.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_select_box_state.dart';

part 'token_select_box_cubit.g.dart';

class TokenSelectBoxCubit extends Cubit<TokenSelectBoxState> {
  TokenSelectBoxCubit({
    required this.tokensCubit,
    required this.insertWithdrawalPageCubit,
  }) : super(const TokenSelectBoxState());

  final TokensCubit tokensCubit;
  final InsertWithdrawalPageCubit insertWithdrawalPageCubit;

  void getBalanceOfAssetList() {
    setLoading(isLoading: true);
    tokensCubit
        .getBalanceOfAssetList(offset: 0, filterTokens: false)
        .then((value) {
      if (value.isNotEmpty) {
        setSelectedToken(tokenModel: value.first);
      }
      setLoading(isLoading: false);
    });
  }

  void setSelectedToken({required TokenModel tokenModel}) {
    insertWithdrawalPageCubit.setSelectedToken(selectedToken: tokenModel);
  }

  void setLoading({required bool isLoading}) {
    emit(state.copyWith(isLoading: isLoading));
  }
}
