part of 'profile_cubit.dart';

@JsonSerializable(explicitToJson: true)
class ProfileState extends Equatable {
  const ProfileState({
    this.status = AppStatus.init,
    this.message,
    required this.model,
    this.allowLogin = true,
  });

  factory ProfileState.fromJson(Map<String, dynamic> json) =>
      _$ProfileStateFromJson(json);

  final AppStatus status;
  final ProfileModel model;
  final StateMessage? message;
  final bool allowLogin;

  Map<String, dynamic> toJson() => _$ProfileStateToJson(this);

  ProfileState loading() {
    final loadingState = ProfileState(
      status: AppStatus.loading,
      model: model,
      allowLogin: allowLogin,
    );
    return loadingState;
  }

  ProfileState error({required MessageHandler messageHandler}) {
    final errorState = ProfileState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      model: model,
      allowLogin: allowLogin,
    );
    return errorState;
  }

  ProfileState copyWith({
    required AppStatus status,
    MessageHandler? messageHandler,
    ProfileModel? model,
    bool? allowLogin,
  }) {
    final profileState = ProfileState(
      status: status,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      model: model ?? this.model,
      allowLogin: allowLogin ?? this.allowLogin,
    );
    return profileState;
  }

  @override
  List<Object?> get props => [status, model, message, allowLogin];
}
