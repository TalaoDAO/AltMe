import 'dart:async';

import 'package:altme/dashboard/dashboard.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_select_box_state.dart';

part 'token_select_box_cubit.g.dart';

class TokenSelectBoxCubit extends Cubit<TokenSelectBoxState> {
  TokenSelectBoxCubit({required TokenModel selectedToken})
      : super(TokenSelectBoxState(selectedToken: selectedToken));

  void setSelectedToken({required TokenModel tokenModel}) {
    emit(state.copyWith(selectedToken: tokenModel));
  }

  void setLoading({required bool isLoading}) {
    emit(state.copyWith(isLoading: isLoading));
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
