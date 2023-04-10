part of 'backup_polygonid_credential_cubit.dart';

@JsonSerializable()
class BackupPolygonIdCredentialState extends Equatable {
  const BackupPolygonIdCredentialState({
    this.status = AppStatus.init,
    this.message,
    this.filePath = '',
  });

  factory BackupPolygonIdCredentialState.fromJson(Map<String, dynamic> json) =>
      _$BackupPolygonIdCredentialStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final String filePath;

  BackupPolygonIdCredentialState loading() {
    return BackupPolygonIdCredentialState(
      status: AppStatus.loading,
      filePath: filePath,
    );
  }

  BackupPolygonIdCredentialState error({
    required MessageHandler messageHandler,
  }) {
    return BackupPolygonIdCredentialState(
      status: AppStatus.error,
      filePath: filePath,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  BackupPolygonIdCredentialState copyWith({
    required AppStatus status,
    MessageHandler? messageHandler,
    String? filePath,
  }) {
    return BackupPolygonIdCredentialState(
      status: status,
      filePath: filePath ?? this.filePath,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
  }

  Map<String, dynamic> toJson() => _$BackupPolygonIdCredentialStateToJson(this);

  @override
  List<Object?> get props => [status, filePath, message];
}
