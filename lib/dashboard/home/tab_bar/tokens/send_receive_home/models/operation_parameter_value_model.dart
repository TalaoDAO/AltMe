import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'operation_parameter_value_model.g.dart';

@JsonSerializable()
class OperationParameterValueModel extends Equatable {
  const OperationParameterValueModel({
    this.to,
    this.from,
    this.value,
  });

  factory OperationParameterValueModel.fromJson(Map<String, dynamic> json) =>
      _$OperationParameterValueModelFromJson(json);

  final String? to;
  final String? from;
  final String? value;

  Map<String, dynamic> toJson() => _$OperationParameterValueModelToJson(this);

  @override
  List<Object?> get props => [to, from, value];
}
