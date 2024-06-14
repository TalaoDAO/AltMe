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
        primary: const Color(0xff1EAADC),
        onPrimary: const Color(0xffFFFFFF),
        onPrimaryContainer: const Color(0xffFFFFFF),
        primaryContainer: const Color(0xFF322643),
        secondary: const Color(0xff00A1FF),
        secondaryContainer: const Color(0xFFECF3FA),
        onSecondary: const Color(0xffFFFFFF),
        tertiary: const Color(0xFF1EA3DC),
        onTertiary: const Color(0xFFECF3FA),
        surface: const Color(0xff191D2E),
        onSurface: const Color(0xffEDEAF5),
        error: const Color(0xffcf6679),
        onError: Colors.black,
        shadow: const Color(0xff1D1D1D).withOpacity(0.1),
        surfaceBright: const Color(0xff191D2E),
        surfaceDim: const Color(0xff020820),
        brightness: Brightness.dark,
      ),
      // textTheme: GoogleFonts.nunitoTextTheme(),
      iconTheme: const IconThemeData(color: Color(0xff1EAADC)),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.green,
        contentTextStyle: GoogleFonts.poppins(
          color: const Color(0xffFFFFFF),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
    );
    return theme.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(theme.textTheme),
    );
  }
}
