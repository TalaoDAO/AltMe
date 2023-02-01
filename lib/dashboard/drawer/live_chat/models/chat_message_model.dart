import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_message_model.g.dart';

@JsonSerializable()
class ChatMessageModel extends Equatable {
  const ChatMessageModel({
    required this.senderId,
    required this.roomId,
    required this.dateTime,
    required this.body,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  final String senderId;
  final String roomId;
  final DateTime dateTime;
  final String body;

  Map<String,dynamic> toJson() => _$ChatMessageModelToJson(this);

  @override
  List<Object?> get props => [
        senderId,
        roomId,
        dateTime,
        body,
      ];
}
