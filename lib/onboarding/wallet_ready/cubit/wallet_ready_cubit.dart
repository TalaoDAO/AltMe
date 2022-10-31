import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet_ready_cubit.g.dart';

part 'wallet_ready_state.dart';

class WalletReadyCubit extends Cubit<WalletReadyState> {
  WalletReadyCubit() : super(const WalletReadyState());

  Future<void> toggleAgreement() async {
    emit(state.copyWith(isAgreeWithTerms: !state.isAgreeWithTerms));
  }
}
