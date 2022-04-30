part of 'profile_cubit.dart';

@JsonSerializable(explicitToJson: true)
class ProfileState extends Equatable {
  const ProfileState({this.message, required this.model});

  factory ProfileState.fromJson(Map<String, dynamic> json) =>
      _$ProfileStateFromJson(json);

  final ProfileModel model;
  final StateMessage? message;

  Map<String, dynamic> toJson() => _$ProfileStateToJson(this);

  ProfileState copyWith({StateMessage? message, ProfileModel? model}) {
    return ProfileState(
      message: message ?? this.message,
      model: model ?? this.model,
    );
  }

  @override
  List<Object?> get props => [model, message];
}
