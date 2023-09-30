import 'package:altme/app/app.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state_message.g.dart';

@JsonSerializable()
class StateMessage extends Equatable {
  const StateMessage({
    this.type = MessageType.error,
    this.messageHandler,
    this.stringMessage,
    this.injectedMessage,
    this.showDialog = false,
    this.erroUrl,
    this.erroDescription,
    this.duration = const Duration(milliseconds: 2 * 800),
  });

  factory StateMessage.fromJson(Map<String, dynamic> json) =>
      _$StateMessageFromJson(json);

  const StateMessage.error({
    this.messageHandler,
    this.stringMessage,
    this.injectedMessage,
    this.showDialog = false,
    this.erroUrl,
    this.erroDescription,
    this.duration = const Duration(milliseconds: 2 * 800),
  }) : type = MessageType.error;

  const StateMessage.warning({
    this.messageHandler,
    this.stringMessage,
    this.injectedMessage,
    this.showDialog = false,
    this.erroUrl,
    this.erroDescription,
    this.duration = const Duration(milliseconds: 2 * 800),
  }) : type = MessageType.warning;

  const StateMessage.info({
    this.messageHandler,
    this.stringMessage,
    this.injectedMessage,
    this.showDialog = false,
    this.erroUrl,
    this.erroDescription,
    this.duration = const Duration(milliseconds: 2 * 800),
  }) : type = MessageType.info;

  const StateMessage.success({
    this.messageHandler,
    this.stringMessage,
    this.injectedMessage,
    this.showDialog = false,
    this.erroUrl,
    this.erroDescription,
    this.duration = const Duration(milliseconds: 2 * 800),
  }) : type = MessageType.success;

  final MessageType type;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final MessageHandler? messageHandler;
  final String? stringMessage;
  final String? injectedMessage;
  final bool showDialog;
  final String? erroUrl;
  final String? erroDescription;
  final Duration duration;

  Map<String, dynamic> toJson() => _$StateMessageToJson(this);

  @override
  List<Object?> get props => [
        type,
        messageHandler,
        stringMessage,
        injectedMessage,
        showDialog,
        duration,
        erroUrl,
        erroDescription,
      ];
}
