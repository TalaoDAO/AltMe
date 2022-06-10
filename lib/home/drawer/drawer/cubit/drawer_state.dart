part of 'drawer_cubit.dart';

class DrawerState {
  const DrawerState({this.isBiometricsEnable = false});

  final bool isBiometricsEnable;

  DrawerState copyWith({bool? isBiometricsEnable}) {
    return DrawerState(
      isBiometricsEnable: isBiometricsEnable ?? this.isBiometricsEnable,
    );
  }
}
