part of 'select_network_fee_cubit.dart';

@JsonSerializable()
class SelectNetworkFeeState extends Equatable {
  SelectNetworkFeeState({
    required this.selectedNetworkFee,
    List<NetworkFeeModel>? networkFeeList,
  }) : networkFeeList = networkFeeList ?? NetworkFeeModel.networks();

  factory SelectNetworkFeeState.fromJson(Map<String, dynamic> json) =>
      _$SelectNetworkFeeStateFromJson(json);

  final NetworkFeeModel selectedNetworkFee;
  final List<NetworkFeeModel> networkFeeList;

  SelectNetworkFeeState copyWith({
    NetworkFeeModel? selectedNetworkFee,
    List<NetworkFeeModel>? networkFeeList,
  }) {
    return SelectNetworkFeeState(
      selectedNetworkFee: selectedNetworkFee ?? this.selectedNetworkFee,
      networkFeeList: networkFeeList ?? this.networkFeeList,
    );
  }

  Map<String, dynamic> toJson() => _$SelectNetworkFeeStateToJson(this);

  @override
  List<Object?> get props => [networkFeeList, selectedNetworkFee];
}
