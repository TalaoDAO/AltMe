part of 'manage_network_cubit.dart';

@JsonSerializable()
class ManageNetworkState extends Equatable {
  const ManageNetworkState({
    required this.network,
    required this.allNetworks,
  });

  factory ManageNetworkState.fromJson(Map<String, dynamic> json) =>
      _$ManageNetworkStateFromJson(json);

  final TezosNetwork network;
  final List<TezosNetwork> allNetworks;

  ManageNetworkState copyWith({
    TezosNetwork? network,
    List<TezosNetwork>? allNetworks,
  }) {
    return ManageNetworkState(
      network: network ?? this.network,
      allNetworks: allNetworks ?? this.allNetworks,
    );
  }

  Map<String, dynamic> toJson() => _$ManageNetworkStateToJson(this);

  @override
  List<Object?> get props => [
        network,
        allNetworks,
      ];
}
