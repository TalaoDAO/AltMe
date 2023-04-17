part of 'backup_polygon_identity_cubit.dart';

@JsonSerializable()
class BackupPolygonIdIdentityState extends Equatable {
  const BackupPolygonIdIdentityState({
    this.status = AppStatus.init,
    this.message,
    this.filePath = '',
  });

  factory BackupPolygonIdIdentityState.fromJson(Map<String, dynamic> json) =>
      _$BackupPolygonIdIdentityStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final String filePath;

  BackupPolygonIdIdentityState loading() {
    return BackupPolygonIdIdentityState(
      status: AppStatus.loading,
      filePath: filePath,
    );
  }

  BackupPolygonIdIdentityState error({
    required MessageHandler messageHandler,
  }) {
    return BackupPolygonIdIdentityState(
      status: AppStatus.error,
      filePath: filePath,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  BackupPolygonIdIdentityState copyWith({
    required AppStatus status,
    MessageHandler? messageHandler,
    String? filePath,
  }) {
    return BackupPolygonIdIdentityState(
      status: status,
      filePath: filePath ?? this.filePath,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
  }

  Map<String, dynamic> toJson() => _$BackupPolygonIdIdentityStateToJson(this);

  @override
  List<Object?> get props => [status, filePath, message];
}
