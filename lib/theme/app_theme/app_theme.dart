import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  static ThemeData get darkThemeData {
    final theme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
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
        surface: const Color(0xff0B0514),
        onSurface: const Color(0xffEDEAF5),
        error: const Color(0xffcf6679),
        onError: Colors.black,
        shadow: const Color(0xff1D1D1D).withOpacity(0.1),
        surfaceBright: const Color(0xff232630),
        surfaceDim: const Color(0xff271C38),
        brightness: Brightness.dark,
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
      tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
    );
    return theme.copyWith(
      textTheme: GoogleFonts.nunitoTextTheme(theme.textTheme),
    );
  }
}
