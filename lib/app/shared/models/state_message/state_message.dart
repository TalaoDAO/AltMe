import 'package:altme/app/app.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
    this.duration = const Duration(milliseconds: 2 * 800),
    this.callToAction,
  });

  factory StateMessage.fromJson(Map<String, dynamic> json) =>
      _$StateMessageFromJson(json);

  const StateMessage.error({
    this.messageHandler,
    this.stringMessage,
    this.injectedMessage,
    this.showDialog = false,
    this.duration = const Duration(milliseconds: 2 * 800),
    this.callToAction,
  }) : type = MessageType.error;

  const StateMessage.warning({
    this.messageHandler,
    this.stringMessage,
    this.injectedMessage,
    this.showDialog = false,
    this.duration = const Duration(milliseconds: 2 * 800),
    this.callToAction,
  }) : type = MessageType.warning;

  const StateMessage.info({
    this.messageHandler,
    this.stringMessage,
    this.injectedMessage,
    this.showDialog = false,
    this.duration = const Duration(milliseconds: 2 * 800),
    this.callToAction,
  }) : type = MessageType.info;

  const StateMessage.success({
    this.messageHandler,
    this.stringMessage,
    this.injectedMessage,
    this.showDialog = false,
    this.duration = const Duration(milliseconds: 2 * 800),
    this.callToAction,
  }) : type = MessageType.success;

  final MessageType type;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final MessageHandler? messageHandler;
  final String? stringMessage;
  final String? injectedMessage;
  final bool showDialog;
  final Duration duration;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Widget? callToAction;

  Map<String, dynamic> toJson() => _$StateMessageToJson(this);

  @override
  List<Object?> get props => [
        type,
        messageHandler,
        stringMessage,
        injectedMessage,
        showDialog,
        duration,
        callToAction,
      ];
}
