import 'package:altme/dashboard/dashboard.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'operation_parameter_model.g.dart';

@JsonSerializable()
class OperationParameterModel extends Equatable {
  const OperationParameterModel({required this.entrypoint, this.value});

  factory OperationParameterModel.fromJson(Map<String, dynamic> json) {
    return OperationParameterModel(
      entrypoint: json['entrypoint'] as String,
      value: (json['value'] is Map)
          ? OperationParameterValueModel.fromJson(
              json['value'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  final String entrypoint;
  final OperationParameterValueModel? value;

  Map<String, dynamic> toJson() => _$OperationParameterModelToJson(this);

  @override
  List<Object?> get props => [entrypoint, value];
}
