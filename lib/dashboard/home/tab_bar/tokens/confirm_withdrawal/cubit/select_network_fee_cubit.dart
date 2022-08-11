import 'package:altme/dashboard/home/tab_bar/tokens/tokens.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'select_network_fee_cubit.g.dart';

part 'select_network_fee_state.dart';

class SelectNetworkFeeCubit extends Cubit<SelectNetworkFeeState> {
  SelectNetworkFeeCubit({
    required NetworkFeeModel selectedNetworkFee,
    this.onChanged,
  }) : super(
          SelectNetworkFeeState(
            selectedNetworkFee: selectedNetworkFee,
            networkFeeList: NetworkFeeModel.networks(),
          ),
        );

  final Function(NetworkFeeModel)? onChanged;

  @override
  void onChange(Change<SelectNetworkFeeState> change) {
    super.onChange(change);
    onChanged?.call(change.nextState.selectedNetworkFee);
  }

  void setSelectedNetworkFee({required NetworkFeeModel selectedNetworkFee}) {
    emit(state.copyWith(selectedNetworkFee: selectedNetworkFee));
  }
}
