import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData defaultThemeData(Brightness brightness) {
    final theme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      dividerColor: const Color(0xFF605A71),
      highlightColor: const Color(0xFF36334E),
      colorScheme: ColorScheme(
        primary: const Color(0xff6600FF),
        onPrimary: const Color(0xffFFFFFF),
        onPrimaryContainer: const Color(0xFF280164),
        primaryContainer: const Color(0xFF322643),
        secondary: const Color(0xFF5F556F),
        secondaryContainer: const Color(0xFF86809D),
        onSecondary: const Color(0xffFFFFFF),
        tertiary: const Color(0xff18ACFF),
        onTertiary: const Color(0xffD1CCE3),
        surface: brightness == Brightness.dark
            ? const Color(0xff0B0514)
            : const Color(0xffEDEAF5),
        onSurface: brightness == Brightness.light
            ? const Color(0xff0B0514)
            : const Color(0xffEDEAF5),
        error: const Color(0xffcf6679),
        onError: Colors.black,
        shadow: const Color(0xff1D1D1D).withOpacity(0.1),
        surfaceBright: const Color(0xff232630),
        surfaceDim: const Color(0xff271C38),
        brightness: brightness,
      ),
      // textTheme: GoogleFonts.nunitoTextTheme(),
      iconTheme: const IconThemeData(color: Color(0xff6600FF)),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.green,
        contentTextStyle: GoogleFonts.roboto(
          color: const Color(0xFFFFFFFF),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      tabBarTheme: const TabBarTheme(),
    );
    return theme.copyWith(
      textTheme: GoogleFonts.nunitoTextTheme(theme.textTheme),
    );
  }

  static ThemeData seedThemeData(Brightness brightness, String primaryColor) {
    if (primaryColor.startsWith('#')) {
      final seedColor = Color(
        int.parse(primaryColor.substring(1, 7), radix: 16) + 0xFF000000,
      );
      final theme = ThemeData(
        useMaterial3: true,
        brightness: brightness,
        snackBarTheme: SnackBarThemeData(
          contentTextStyle: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
      );
      return theme.copyWith(
        textTheme: GoogleFonts.robotoTextTheme(theme.textTheme),
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: brightness,
        ),
      );
    }
    return defaultThemeData(brightness);
  }
}
