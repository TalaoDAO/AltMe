part of 'biometrics_cubit.dart';

@JsonSerializable()
class BiometricsState extends Equatable {
  const BiometricsState({this.isBiometricsEnabled = false});

  factory BiometricsState.fromJson(Map<String, dynamic> json) =>
      _$BiometricsStateFromJson(json);

  final bool isBiometricsEnabled;

  BiometricsState copyWith({bool? isBiometricsEnabled}) {
    return BiometricsState(
      isBiometricsEnabled: isBiometricsEnabled ?? this.isBiometricsEnabled,
    );
  }

  Map<String, dynamic> toJson() => _$BiometricsStateToJson(this);

  @override
  List<Object?> get props => [isBiometricsEnabled];
}
