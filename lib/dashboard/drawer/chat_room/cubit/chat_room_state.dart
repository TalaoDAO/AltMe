part of 'chat_room_cubit.dart';

@JsonSerializable()
class ChatRoomState extends Equatable {
  const ChatRoomState({
    this.status = AppStatus.idle,
    this.messages = const <Message>[],
    this.user,
    this.message,
  });

  factory ChatRoomState.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomStateFromJson(json);

  final AppStatus status;
  final List<Message> messages;
  final StateMessage? message;
  final User? user;

  Map<String, dynamic> toJson() => _$ChatRoomStateToJson(this);

  ChatRoomState copyWith({
    AppStatus? status,
    List<Message>? messages,
    User? user,
    StateMessage? message,
  }) {
    return ChatRoomState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        status,
        messages,
        user,
        message,
      ];
}
