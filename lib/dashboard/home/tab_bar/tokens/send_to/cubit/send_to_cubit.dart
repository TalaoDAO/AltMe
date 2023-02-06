import 'package:altme/wallet/model/crypto_account_data.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'send_to_state.dart';

part 'send_to_cubit.g.dart';

class SendToCubit extends Cubit<SendToState> {
  SendToCubit() : super(const SendToState());

  void setSelectedAccount({required CryptoAccountData selectedAccount}) {
    emit(state.copyWith(selectedAccount: selectedAccount));
  }

  void setWithdrawalAddress({required String withdrawalAddress}) {
    emit(state.copyWith(withdrawalAddress: withdrawalAddress));
  }
}
