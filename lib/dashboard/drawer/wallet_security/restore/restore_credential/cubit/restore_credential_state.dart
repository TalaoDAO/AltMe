part of 'restore_credential_cubit.dart';

@JsonSerializable()
class RestoreCredentialState extends Equatable {
  const RestoreCredentialState({
    this.status = AppStatus.init,
    this.message,
    this.recoveredCredentialLength,
    this.backupFilePath,
  });

  factory RestoreCredentialState.fromJson(Map<String, dynamic> json) =>
      _$RestoreCredentialStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final int? recoveredCredentialLength;
  final String? backupFilePath;

  RestoreCredentialState loading() {
    return copyWith(
      status: AppStatus.loading,
      recoveredCredentialLength: recoveredCredentialLength,
    );
  }

  RestoreCredentialState error({required MessageHandler messageHandler}) {
    return copyWith(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      recoveredCredentialLength: recoveredCredentialLength,
    );
  }

  RestoreCredentialState success({
    MessageHandler? messageHandler,
    int? recoveredCredentialLength,
  }) {
    return copyWith(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      recoveredCredentialLength:
          recoveredCredentialLength ?? this.recoveredCredentialLength,
    );
  }

  RestoreCredentialState copyWith({
    AppStatus? status,
    StateMessage? message,
    int? recoveredCredentialLength,
    String? backupFilePath,
  }) {
    return RestoreCredentialState(
      status: status ?? this.status,
      message: message ?? this.message,
      recoveredCredentialLength:
          recoveredCredentialLength ?? this.recoveredCredentialLength,
      backupFilePath: backupFilePath ?? this.backupFilePath,
    );
  }

  Map<String, dynamic> toJson() => _$RestoreCredentialStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        message,
        recoveredCredentialLength,
        backupFilePath,
      ];
}
