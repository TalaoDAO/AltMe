part of 'recovery_key_cubit.dart';

@JsonSerializable()
class RecoveryKeyState extends Equatable {
  const RecoveryKeyState({
    this.status = AppStatus.init,
    this.message,
    this.mnemonics,
    this.hasVerifiedMnemonics = false,
  });

  factory RecoveryKeyState.fromJson(Map<String, dynamic> json) =>
      _$RecoveryKeyStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final List<String>? mnemonics;
  final bool hasVerifiedMnemonics;

  RecoveryKeyState loading() {
    return copyWith(status: AppStatus.loading);
  }

  RecoveryKeyState error({required MessageHandler messageHandler}) {
    return copyWith(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      mnemonics: mnemonics,
    );
  }

  RecoveryKeyState copyWith({
    AppStatus? status,
    StateMessage? message,
    List<String>? mnemonics,
    bool? hasVerifiedMnemonics,
  }) {
    return RecoveryKeyState(
      status: status ?? this.status,
      mnemonics: mnemonics ?? this.mnemonics,
      hasVerifiedMnemonics: hasVerifiedMnemonics ?? this.hasVerifiedMnemonics,
    );
  }

  Map<String, dynamic> toJson() => _$RecoveryKeyStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        message,
        mnemonics,
        hasVerifiedMnemonics,
      ];
}
