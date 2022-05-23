part of 'profile_cubit.dart';

@JsonSerializable(explicitToJson: true)
class ProfileState extends Equatable {
  const ProfileState({
    this.status = AppStatus.init,
    this.message,
    required this.model,
  });

  factory ProfileState.fromJson(Map<String, dynamic> json) =>
      _$ProfileStateFromJson(json);

  final AppStatus status;
  final ProfileModel model;
  final StateMessage? message;

  Map<String, dynamic> toJson() => _$ProfileStateToJson(this);

  ProfileState loading() {
    return ProfileState(status: AppStatus.loading, model: model);
  }

  ProfileState error({required MessageHandler messageHandler}) {
    return ProfileState(
        status: AppStatus.error,
        message: StateMessage.error(messageHandler: messageHandler),
        model: model,);
  }

  ProfileState success({MessageHandler? messageHandler, ProfileModel? model}) {
    return ProfileState(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      model: model ?? this.model,
    );
  }

  @override
  List<Object?> get props => [status, model, message];
}
