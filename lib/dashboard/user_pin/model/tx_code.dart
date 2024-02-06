import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tx_code.g.dart';

@JsonSerializable()
class TxCode extends Equatable {
  const TxCode({
    required this.length,
    required this.inputMode,
    required this.description,
  });

  factory TxCode.fromJson(Map<String, dynamic> json) => _$TxCodeFromJson(json);

  final int length;
  @JsonKey(name: 'input_mode')
  final String inputMode;
  final String description;

  Map<String, dynamic> toJson() => _$TxCodeToJson(this);

  @override
  List<Object?> get props => [
        length,
        inputMode,
        description,
      ];
}
