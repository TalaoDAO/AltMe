import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:secure_storage/secure_storage.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this.secureStorageProvider) : super(ThemeMode.light);

  final SecureStorageProvider secureStorageProvider;

  Future<void> setLightTheme() async {
    await secureStorageProvider.set('theme', 'light');
    setTheme(ThemeMode.light);
  }

  Future<void> setDarkTheme() async {
    await secureStorageProvider.set('theme', 'dark');
    setTheme(ThemeMode.dark);
  }

  Future<void> setSystemTheme() async {
    await secureStorageProvider.set('theme', 'system');
    setTheme(ThemeMode.system);
  }

  void setTheme(ThemeMode? themeMode) {
    if (themeMode != null) emit(themeMode);
  }

  Future<void> getCurrentTheme() async {
    final theme = await secureStorageProvider.get('theme') ?? '';
    if (theme.isNotEmpty) {
      if (theme == 'light') {
        setTheme(ThemeMode.light);
      } else if (theme == 'dark') {
        setTheme(ThemeMode.dark);
      } else if (theme == 'system') {
        setTheme(ThemeMode.system);
      } else {
        setTheme(ThemeMode.dark);
      }
    }
  }
}
