// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manage_network_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManageNetworkState _$ManageNetworkStateFromJson(Map<String, dynamic> json) =>
    ManageNetworkState(
      network: BlockchainNetwork.fromJson(
        json['network'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ManageNetworkStateToJson(ManageNetworkState instance) =>
    <String, dynamic>{'network': instance.network};
