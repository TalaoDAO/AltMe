part of 'backup_credential_cubit.dart';

@JsonSerializable()
class BackupCredentialState extends Equatable {
  const BackupCredentialState({
    this.status = AppStatus.init,
    this.message,
    this.filePath = '',
  });

  factory BackupCredentialState.fromJson(Map<String, dynamic> json) =>
      _$BackupCredentialStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final String filePath;

  BackupCredentialState loading() {
    final loadingState = BackupCredentialState(
      status: AppStatus.loading,
      filePath: filePath,
    );
    return loadingState;
  }

  BackupCredentialState error({required MessageHandler messageHandler}) {
    final errorState = BackupCredentialState(
      status: AppStatus.error,
      filePath: filePath,
      message: StateMessage.error(messageHandler: messageHandler),
    );
    return errorState;
  }

  BackupCredentialState copyWith({
    required AppStatus status,
    MessageHandler? messageHandler,
    String? filePath,
  }) {
    final updatedState = BackupCredentialState(
      status: status,
      filePath: filePath ?? this.filePath,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
    return updatedState;
  }

  Map<String, dynamic> toJson() => _$BackupCredentialStateToJson(this);

  @override
  List<Object?> get props => [status, filePath, message];
}
