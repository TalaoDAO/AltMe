part of 'manage_network_cubit.dart';

@JsonSerializable()
class ManageNetworkState extends Equatable {
  const ManageNetworkState({
    required this.network,
  });

  factory ManageNetworkState.fromJson(Map<String, dynamic> json) =>
      _$ManageNetworkStateFromJson(json);

  final TezosNetwork network;
  List<TezosNetwork> get allNetworks => [
        TezosNetwork.mainNet(),
        TezosNetwork.ghostnet(),
      ];

  ManageNetworkState copyWith({
    TezosNetwork? network,
  }) {
    return ManageNetworkState(
      network: network ?? this.network,
    );
  }

  Map<String, dynamic> toJson() => _$ManageNetworkStateToJson(this);

  @override
  List<Object?> get props => [
        network,
        allNetworks,
      ];
}
