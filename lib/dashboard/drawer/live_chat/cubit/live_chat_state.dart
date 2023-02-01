part of 'live_chat_cubit.dart';

@JsonSerializable()
class LiveChatState extends Equatable {
  const LiveChatState({
    this.status = AppStatus.idle,
  });

  factory LiveChatState.fromJson(Map<String, dynamic> json) =>
      _$LiveChatStateFromJson(json);

  final AppStatus status;

  Map<String, dynamic> toJson() => _$LiveChatStateToJson(this);

  LiveChatState copyWith({AppStatus? status}) {
    return LiveChatState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [
        status,
      ];
}
