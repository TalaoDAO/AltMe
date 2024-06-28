import 'package:altme/app/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppTheme {
  static ThemeData seedThemeData(Brightness brightness, String? primaryColor) {
    late Color seedColor;

    try {
      seedColor = Color(
        int.parse(primaryColor!.substring(1, 7), radix: 16) + 0xFF000000,
      );
    } catch (e) {
      seedColor = Parameters.seedColor;
    }

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
