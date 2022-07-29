part of 'manage_network_cubit.dart';

class ManageNetworkState extends Equatable {
  const ManageNetworkState({required this.network});

  final TezosNetwork network;

  ManageNetworkState copyWith({TezosNetwork? network}) {
    return ManageNetworkState(network: network ?? this.network);
  }

  @override
  List<Object?> get props => [network];
}
