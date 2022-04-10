import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:secure_storage/secure_storage.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this.secureStorageProvider) : super(ThemeMode.light);

  final SecureStorageProvider secureStorageProvider;

  void setLightTheme() {
    secureStorageProvider.set(AltMeStrings.theme, AltMeStrings.light);
    setTheme(ThemeMode.light);
  }

  void setDarkTheme() {
    secureStorageProvider.set(AltMeStrings.theme, AltMeStrings.dark);
    setTheme(ThemeMode.dark);
  }

  void setSystemTheme() {
    secureStorageProvider.set(AltMeStrings.theme, AltMeStrings.system);
    setTheme(ThemeMode.system);
  }

  void setTheme(ThemeMode? themeMode) {
    if (themeMode != null) emit(themeMode);
  }

  Future<void> getCurrentTheme() async {
    final theme = await secureStorageProvider.get(AltMeStrings.theme) ?? '';
    if (theme.isNotEmpty) {
      if (theme == AltMeStrings.light) {
        setTheme(ThemeMode.light);
      } else if (theme == AltMeStrings.dark) {
        setTheme(ThemeMode.dark);
      } else if (theme == AltMeStrings.system) {
        setTheme(ThemeMode.system);
      } else {
        setTheme(ThemeMode.light);
      }
    }
  }
}
