import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeModeCubit extends Cubit<ThemeMode> {
  ThemeModeCubit() : super(ThemeMode.dark);

  void _changeThemeMode(ThemeMode themeMode) {
    emit(themeMode);
  }

  void setLightTheme() {
    _changeThemeMode(ThemeMode.light);
  }

  void setDarkTheme() {
    _changeThemeMode(ThemeMode.dark);
  }

  void setSystemTheme() {
    _changeThemeMode(ThemeMode.system);
  }
}
