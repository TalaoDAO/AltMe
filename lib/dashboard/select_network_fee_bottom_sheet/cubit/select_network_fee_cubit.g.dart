// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_network_fee_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectNetworkFeeState _$SelectNetworkFeeStateFromJson(
        Map<String, dynamic> json) =>
    SelectNetworkFeeState(
      selectedNetworkFee: NetworkFeeModel.fromJson(
          json['selectedNetworkFee'] as Map<String, dynamic>),
      networkFeeList: (json['networkFeeList'] as List<dynamic>?)
          ?.map((e) => NetworkFeeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SelectNetworkFeeStateToJson(
        SelectNetworkFeeState instance) =>
    <String, dynamic>{
      'selectedNetworkFee': instance.selectedNetworkFee,
      'networkFeeList': instance.networkFeeList,
    };
