part of 'drawer_cubit.dart';

@JsonSerializable()
class DrawerState extends Equatable {
  const DrawerState({this.isBiometricsEnabled = false});

  factory DrawerState.fromJson(Map<String, dynamic> json) =>
      _$DrawerStateFromJson(json);

  final bool isBiometricsEnabled;

  DrawerState copyWith({bool? isBiometricsEnabled}) {
    return DrawerState(
      isBiometricsEnabled: isBiometricsEnabled ?? this.isBiometricsEnabled,
    );
  }

  Map<String, dynamic> toJson() => _$DrawerStateToJson(this);

  @override
  List<Object?> get props => [isBiometricsEnabled];
}
