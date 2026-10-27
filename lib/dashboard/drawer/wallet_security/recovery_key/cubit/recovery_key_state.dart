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
    final loadingState = copyWith(status: AppStatus.loading);
    return loadingState;
  }

  RecoveryKeyState error({required MessageHandler messageHandler}) {
    final errorState = copyWith(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      mnemonics: mnemonics,
    );
    return errorState;
  }

  RecoveryKeyState copyWith({
    AppStatus? status,
    StateMessage? message,
    List<String>? mnemonics,
    bool? hasVerifiedMnemonics,
  }) {
    final updatedState = RecoveryKeyState(
      status: status ?? this.status,
      mnemonics: mnemonics ?? this.mnemonics,
      hasVerifiedMnemonics: hasVerifiedMnemonics ?? this.hasVerifiedMnemonics,
    );
    return updatedState;
  }

  Map<String, dynamic> toJson() => _$RecoveryKeyStateToJson(this);

  @override
  List<Object?> get props => [status, message, mnemonics, hasVerifiedMnemonics];
}
