part of 'live_chat_cubit.dart';

@JsonSerializable()
class LiveChatState extends Equatable {
  const LiveChatState({
    this.status = AppStatus.idle,
    this.messages = const <Message>[],
    this.user,
  });

  factory LiveChatState.fromJson(Map<String, dynamic> json) =>
      _$LiveChatStateFromJson(json);

  final AppStatus status;
  final List<Message> messages;
  final User? user;

  Map<String, dynamic> toJson() => _$LiveChatStateToJson(this);

  LiveChatState copyWith({
    AppStatus? status,
    List<Message>? messages,
    User? user,
  }) {
    return LiveChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
        status,
        messages,
        user,
      ];
}
