part of 'biometrics_cubit.dart';

@JsonSerializable()
class BiometricsState extends Equatable {
  const BiometricsState({
    this.status = AppStatus.init,
    this.message,
    this.isBiometricsEnabled = false,
  });

  factory BiometricsState.fromJson(Map<String, dynamic> json) =>
      _$BiometricsStateFromJson(json);

  final bool isBiometricsEnabled;
  final AppStatus status;
  final StateMessage? message;

  BiometricsState loading() {
    return BiometricsState(
      status: AppStatus.loading,
      isBiometricsEnabled: isBiometricsEnabled,
    );
  }

  BiometricsState error({
    required MessageHandler messageHandler,
  }) {
    return BiometricsState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      isBiometricsEnabled: isBiometricsEnabled,
    );
  }

  BiometricsState success({
    MessageHandler? messageHandler,
    String? filePath,
  }) {
    return BiometricsState(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      isBiometricsEnabled: isBiometricsEnabled,
    );
  }

  BiometricsState copyWith({bool? isBiometricsEnabled}) {
    return BiometricsState(
      isBiometricsEnabled: isBiometricsEnabled ?? this.isBiometricsEnabled,
    );
  }

  Map<String, dynamic> toJson() => _$BiometricsStateToJson(this);

  @override
  List<Object?> get props => [status, message, isBiometricsEnabled];
}
