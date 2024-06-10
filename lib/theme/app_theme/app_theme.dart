import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  /// A color frequently across your app’s screens and components.
  static Color darkPrimary = const Color(0xff6600FF);

  /// A color that's clearly legible when drawn on primary
  static Color darkOnPrimary = const Color(0xffFFFFFF);

  /// An accent color used for less prominent components in the UI, such as
  /// filter chips, while expanding the opportunity for color expression.
  static Color darkSecondary = const Color(0xff18ACFF);

  /// A color that's clearly legible when drawn on secondary
  static Color darkOnSecondary = const Color(0xffFFFFFF);

  /// A color used as a contrasting accent that can balance primary
  /// and secondary colors or bring heightened attention to an element,
  /// such as an input field.
  static Color darkTertiary = const Color(0xFF280164);

  /// A color that's clearly legible when drawn on tertiary.
  static Color darkOnTertiary = const Color(0xffD1CCE3);

  /// The background color for widgets like Card.
  static Color darkSurface = const Color(0xff0B0514);

  /// A color that's clearly legible when drawn on surface.
  static Color darkOnSurface = const Color(0xffEDEAF5);

  /// A color that typically appears behind scrollable content.
  static Color darkBackground = const Color(0xff0B0514);

  /// A color that's clearly legible when drawn on background.
  static Color darkOnBackground = const Color(0xffFFFFFF);

  /// The color to use for input validation errors, e.g. for
  /// InputDecoration.errorText
  static const Color darkError = Color(0xffcf6679);

  /// A color that's clearly legible when drawn on error.
  static const Color darkOnError = Colors.black;

  /// A color use to paint the drop shadows of elevated components.
  static Color darkShadow = const Color(0xff1D1D1D).withOpacity(0.1);

  static Color dividerColor = const Color(0xFF605A71);

  static Color highlightColor = const Color(0xFF36334E);

  static ThemeData get darkThemeData => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        dividerColor: dividerColor,
        highlightColor: highlightColor,
        colorScheme: ColorScheme(
          primary: const Color(0xff6600FF),
          onPrimary: darkOnPrimary,
          secondary: darkSecondary,
          onSecondary: darkOnSecondary,
          tertiary: darkTertiary,
          onTertiary: darkOnTertiary,
          surface: const Color(0xff0B0514),
          onSurface: darkOnSurface,
          error: darkError,
          onError: darkOnError,
          shadow: darkShadow,
          surfaceBright: const Color(0xff232630),
          surfaceDim: const Color(0xff271C38),
          brightness: Brightness.dark,
        ),
        textTheme: TextTheme(
          bodySmall: GoogleFonts.nunito(
            color: const Color(0xFFFFFFFF),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: GoogleFonts.nunito(
            color: const Color(0xFFFFFFFF),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: GoogleFonts.nunito(
            color: const Color(0xFFFFFFFF),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: GoogleFonts.nunito(
            color: const Color(0xFFFFFFFF),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
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
}
