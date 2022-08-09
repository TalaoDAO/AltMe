import 'dart:async';

import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/withdrawal_tokens/withdrawal_tokens.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_select_box_state.dart';

part 'token_select_box_cubit.g.dart';

class TokenSelectBoxCubit extends Cubit<TokenSelectBoxState> {
  TokenSelectBoxCubit({required this.controller})
      : super(TokenSelectBoxState(selectedToken: controller.state)) {
    _addTokenSelectBoxSubscription();
  }

  late final StreamSubscription _tokenSelectBoxSubscription;

  void _addTokenSelectBoxSubscription() {
    _tokenSelectBoxSubscription =
        controller.stream.listen(_onControllerChangeListener);
  }

  Future<void> _removeTokenSelectBoxSubscription() {
    return _tokenSelectBoxSubscription.cancel();
  }

  void _onControllerChangeListener(TokenModel selectedToken) {
    if (state.selectedToken != selectedToken) {
      emit(state.copyWith(selectedToken: selectedToken));
    }
  }

  final TokenSelectBoxController controller;

  void setSelectedToken({required TokenModel tokenModel}) {
    controller.setSelectedAccount(selectedToken: tokenModel);
    emit(state.copyWith(selectedToken: tokenModel));
  }

  @override
  Future<void> close() {
    _removeTokenSelectBoxSubscription();
    controller.close();
    return super.close();
  }
}
