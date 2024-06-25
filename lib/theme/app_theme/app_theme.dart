import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData seedThemeData(Brightness brightness, String primaryColor) {
    // final seedColor = Colors.blue;
    // altme
    final seedColor = const Color(0xff6600FF);
    // talao
    // final seedColor = const Color(0xff1EAADC);

    final theme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      snackBarTheme: const SnackBarThemeData(
        contentTextStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
        ),
      ),
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
    return theme.copyWith(
      textTheme: GoogleFonts.nunitoTextTheme(theme.textTheme),
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      ),
    );
  }
}
