import 'package:altme/app/app.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state_message.g.dart';

@JsonSerializable()
class StateMessage extends Equatable {
  const StateMessage({this.type, this.errorHandler});

  factory StateMessage.fromJson(Map<String, dynamic> json) =>
      _$StateMessageFromJson(json);

  const StateMessage.error({this.errorHandler}) : type = MessageType.error;

  const StateMessage.warning({this.errorHandler}) : type = MessageType.warning;

  const StateMessage.info({this.errorHandler}) : type = MessageType.info;

  const StateMessage.success({this.errorHandler}) : type = MessageType.success;

  final MessageType? type;
  @JsonKey(ignore: true)
  final ErrorHandler? errorHandler;

  Map<String, dynamic> toJson() => _$StateMessageToJson(this);

  @override
  List<Object?> get props => [type, errorHandler];
}
