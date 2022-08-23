import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'operation_address_model.g.dart';

@JsonSerializable()
class OperationAddressModel extends Equatable {
  const OperationAddressModel({required this.address, this.alias});

  factory OperationAddressModel.fromJson(Map<String, dynamic> json) =>
      _$OperationAddressModelFromJson(json);

  final String address;
  final String? alias;

  Map<String, dynamic> toJson() => _$OperationAddressModelToJson(this);

  @override
  List<Object?> get props => [address, alias];
}
