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

  Future<void> getBalanceOfAssetList() async {
    final defaultData = tokensCubit.state.data;
    if (defaultData.isEmpty ||
        !defaultData.map((e) => e.symbol).contains(
              insertWithdrawalPageCubit.defaultSelectedToken.symbol,
            )) {
      setLoading(isLoading: true);
      await tokensCubit.getTokens();
      if (tokensCubit.state.data.isNotEmpty) {
        setSelectedToken(tokenModel: tokensCubit.state.data.first);
      }
      setLoading(isLoading: false);
    } else {
      await tokensCubit.getTokens();
      if (tokensCubit.state.data.isNotEmpty &&
          !tokensCubit.state.data.map((e) => e.symbol).contains(
                insertWithdrawalPageCubit.defaultSelectedToken.symbol,
              )) {
        setSelectedToken(tokenModel: tokensCubit.state.data.first);
      }
    }
  }

  void setSelectedToken({required TokenModel tokenModel}) {
    insertWithdrawalPageCubit.setSelectedToken(selectedToken: tokenModel);
  }

  void setLoading({required bool isLoading}) {
    emit(state.copyWith(isLoading: isLoading));
  }
}
