import 'package:altme/app/app.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state_message.g.dart';

@JsonSerializable()
class StateMessage extends Equatable {
  const StateMessage({
    this.type = MessageType.error,
    this.messageHandler,
  });

  factory StateMessage.fromJson(Map<String, dynamic> json) =>
      _$StateMessageFromJson(json);

  const StateMessage.error({this.messageHandler}) : type = MessageType.error;

  const StateMessage.warning({this.messageHandler})
      : type = MessageType.warning;

  const StateMessage.info({this.messageHandler}) : type = MessageType.info;

  const StateMessage.success({this.messageHandler})
      : type = MessageType.success;

  final MessageType? type;
  @JsonKey(ignore: true)
  final MessageHandler? messageHandler;

  Map<String, dynamic> toJson() => _$StateMessageToJson(this);

  @override
  List<Object?> get props => [type, messageHandler];
}
