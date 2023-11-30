part of 'submit_enterprise_user_cubit.dart';

@JsonSerializable()
class SubmitEnterpriseUserState extends Equatable {
  const SubmitEnterpriseUserState({
    this.status = AppStatus.init,
    this.message,
    this.rsaFile,
    this.did = '',
  });

  factory SubmitEnterpriseUserState.fromJson(Map<String, dynamic> json) =>
      _$SubmitEnterpriseUserStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final PlatformFile? rsaFile;
  final String did;

  SubmitEnterpriseUserState loading() {
    return SubmitEnterpriseUserState(
      status: AppStatus.loading,
      rsaFile: rsaFile,
      did: did,
    );
  }

  SubmitEnterpriseUserState error({
    required MessageHandler messageHandler,
  }) {
    return SubmitEnterpriseUserState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      rsaFile: rsaFile,
      did: did,
    );
  }

  SubmitEnterpriseUserState success({
    MessageHandler? messageHandler,
    PlatformFile? rsaFile,
    String? did,
  }) {
    return SubmitEnterpriseUserState(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      rsaFile: rsaFile ?? this.rsaFile,
      did: did ?? this.did,
    );
  }

  Map<String, dynamic> toJson() => _$SubmitEnterpriseUserStateToJson(this);

  @override
  List<Object?> get props => [status, rsaFile, message, did];
}
