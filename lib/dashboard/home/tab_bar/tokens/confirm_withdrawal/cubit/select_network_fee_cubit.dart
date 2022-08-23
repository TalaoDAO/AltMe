import 'package:altme/dashboard/home/tab_bar/tokens/tokens.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'select_network_fee_cubit.g.dart';

part 'select_network_fee_state.dart';

class SelectNetworkFeeCubit extends Cubit<SelectNetworkFeeState> {
  SelectNetworkFeeCubit({
    required NetworkFeeModel selectedNetworkFee,
    required this.confirmWithdrawalCubit,
  }) : super(SelectNetworkFeeState(selectedNetworkFee: selectedNetworkFee));

  final ConfirmWithdrawalCubit confirmWithdrawalCubit;

  void setSelectedNetworkFee({required NetworkFeeModel selectedNetworkFee}) {
    confirmWithdrawalCubit.setNetworkFee(networkFee: selectedNetworkFee);
    emit(state.copyWith(selectedNetworkFee: selectedNetworkFee));
  }
}
