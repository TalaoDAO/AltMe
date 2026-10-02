part of 'select_network_fee_cubit.dart';

@JsonSerializable()
class SelectNetworkFeeState extends Equatable {
  SelectNetworkFeeState({
    required this.selectedNetworkFee,
    List<NetworkFeeModel>? networkFeeList,
  }) : networkFeeList = networkFeeList ?? [];

  factory SelectNetworkFeeState.fromJson(Map<String, dynamic> json) =>
      _$SelectNetworkFeeStateFromJson(json);

  final NetworkFeeModel selectedNetworkFee;
  final List<NetworkFeeModel> networkFeeList;

  SelectNetworkFeeState copyWith({
    NetworkFeeModel? selectedNetworkFee,
    List<NetworkFeeModel>? networkFeeList,
  }) {
    final selectNetworkFeeState = SelectNetworkFeeState(
      selectedNetworkFee: selectedNetworkFee ?? this.selectedNetworkFee,
      networkFeeList: networkFeeList ?? this.networkFeeList,
    );
    return selectNetworkFeeState;
  }

  Map<String, dynamic> toJson() => _$SelectNetworkFeeStateToJson(this);

  @override
  List<Object?> get props => [networkFeeList, selectedNetworkFee];
}
