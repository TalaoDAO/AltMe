import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {

  static const Color darkPrimary = Color(0xffbb86fc);
  static const Color darkPrimaryContainer = Color(0xff3700B3);
  static const Color darkSecondary = Color(0xff03dac6);
  static const Color darkSecondaryContainer = Color(0xff03dac6);
  static const Color darkSurface = Color(0xff212121);
  static const Color darkBackground = Color(0xff121212);
  static const Color darkError = Color(0xffcf6679);
  static const Color darkOnPrimary = Colors.black;
  static const Color darkOnSecondary = Colors.black;
  static const Color darkOnSurface = Colors.white;
  static const Color darkOnBackground = Colors.white;
  static const Color darkOnError = Colors.black;
  static Color darkShadow = const Color(0xFF1D1D1D).withOpacity(0.1);

  static const Color lightPrimary = Color(0xff6200ee);
  static const Color lightPrimaryContainer = Color(0xff3700b3);
  static const Color lightSecondary = Color(0xff03dac6);
  static const Color lightSecondaryContainer = Color(0xff018786);
  static const Color lightSurface = Colors.white;
  static const Color lightBackground = Colors.white;
  static const Color lightError = Color(0xffb00020);
  static const Color lightOnPrimary = Colors.white;
  static const Color lightOnSecondary = Colors.black;
  static const Color lightOnSurface = Colors.black;
  static const Color lightOnBackground = Colors.black;
  static const Color lightOnError = Colors.white;
  static const Color lightShadow = Color(0xFFADACAC);

  static SnackBarThemeData get snackBarThemeData => SnackBarThemeData(
        backgroundColor: Colors.green,
        contentTextStyle: GoogleFonts.nunito(
          color: const Color(0xFFFFFFFF),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      );

  static ThemeData get darkThemeData => ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme(
          primary: darkPrimary,
          primaryContainer: darkPrimaryContainer,
          secondary: darkSecondary,
          secondaryContainer: darkSecondaryContainer,
          surface: darkSurface,
          background: darkBackground,
          error: darkError,
          onPrimary: darkOnPrimary,
          onSecondary: darkOnSecondary,
          onSurface: darkOnSurface,
          onBackground: darkOnBackground,
          onError: darkOnError,
          shadow: darkShadow,
          brightness: Brightness.dark,
        ),
        textTheme: TextTheme(
          subtitle1: GoogleFonts.nunito(
            color: const Color(0xFFFFFFFF),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          subtitle2: GoogleFonts.nunito(
            color: const Color(0xFF8B8C92),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          bodyText1: GoogleFonts.nunito(
            color: const Color(0xFF8B8C92),
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          bodyText2: GoogleFonts.nunito(
            color: const Color(0xFFFFFFFF),
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          button: GoogleFonts.nunito(
            color: const Color(0xFFFFFFFF),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          overline: GoogleFonts.nunito(
            color: const Color(0xFFFFFFFF),
            fontSize: 10,
            letterSpacing: 0,
          ),
          caption: GoogleFonts.nunito(
            color: const Color(0xFFFFFFFF),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFFFFFFF)),
        snackBarTheme: snackBarThemeData,
      );

  static ThemeData get lightThemeData => ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme(
          primary: lightPrimary,
          primaryContainer: lightPrimaryContainer,
          secondary: lightSecondary,
          secondaryContainer: lightSecondaryContainer,
          surface: lightSurface,
          background: lightBackground,
          error: lightError,
          onPrimary: lightOnPrimary,
          onSecondary: lightOnSecondary,
          onSurface: lightOnSurface,
          onBackground: lightOnBackground,
          onError: lightOnError,
          shadow: lightShadow,
          brightness: Brightness.light,
        ),
        textTheme: TextTheme(
          subtitle1: GoogleFonts.nunito(
            color: const Color(0xff212121),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          subtitle2: GoogleFonts.nunito(
            color: const Color(0xFFA4A5AC),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          bodyText1: GoogleFonts.nunito(
            color: const Color(0xff212121),
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          bodyText2: GoogleFonts.nunito(
            color: const Color(0xff212121),
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          button: GoogleFonts.nunito(
            color: const Color(0xff212121),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          overline: GoogleFonts.nunito(
            color: const Color(0xff212121),
            fontSize: 10,
            letterSpacing: 0,
          ),
          caption: GoogleFonts.nunito(
            color: const Color(0xff212121),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xff212121)),
        snackBarTheme: snackBarThemeData,
      );
}
//
// extension CustomColorScheme on ColorScheme {
//   Color get transparent => Colors.transparent;
//
//   Color get appBar => brightness == Brightness.light
//       ? const Color(0xFFFFFFFF)
//       : const Color(0xFF1D1D1D);
//
//   Color get backButton => brightness == Brightness.light
//       ? const Color(0xFF1D1D1D)
//       : const Color(0xFFADACAC);
//
//   Color get selectedBottomBar => brightness == Brightness.light
//       ? AppTheme.lightOnSurface
//       : AppTheme.darkOnSurface;
//
//   Color get borderColor => brightness == Brightness.light
//       ? const Color(0xFFEEEAEA)
//       : const Color(0xFF3B3A3A);
//
//   Color get markDownH1 => brightness == Brightness.light
//       ? AppTheme.lightOnSurface
//       : const Color(0xFFDBD8D8);
//
//   Color get markDownH2 => brightness == Brightness.light
//       ? AppTheme.lightOnSurface
//       : const Color(0xFFDBD8D8);
//
//   Color get markDownP => brightness == Brightness.light
//       ? AppTheme.lightOnSurface
//       : const Color(0xFFADACAC);
//
//   Color get markDownA => brightness == Brightness.light
//       ? const Color(0xff3700b3)
//       : const Color(0xff517bff);
//
//   Color get subtitle1 => brightness == Brightness.light
//       ? const Color(0xff212121)
//       : const Color(0xFFFFFFFF);
//
//   Color get subtitle2 => brightness == Brightness.light
//       ? const Color(0xff212121)
//       : const Color(0xFF8B8C92);
//
//   Color get button => brightness == Brightness.light
//       ? const Color(0xff212121)
//       : const Color(0xFFEEEAEA);
//
//   Color get profileDummy => brightness == Brightness.light
//       ? const Color(0xFFE0E0E0)
//       : const Color(0xFF212121);
//
//   Color get documentShadow => brightness == Brightness.light
//       ? const Color(0xFF757575)
//       : const Color(0xFF424242);
//
//   Color get documentShape => AppTheme.lightPrimaryContainer.withOpacity(0.5);
//
//   Color get star => const Color(0xFFFFB83D);
//
//   Color get genderIcon => const Color(0xFF212121);
//
//   Color get activeCredential => Colors.green;
//
//   Color get expiredCredential => Colors.orange;
//
//   Color get revokedCredential => Colors.red;
//
//   Color get buttonDisabled => brightness == Brightness.light
//       ? const Color(0xFFADACAC)
//       : const Color(0xFF424242);
//
//   Color get alertErrorMessage => Colors.red;
//
//   Color get alertWarningMessage => Colors.yellow;
//
//   Color get alertInfoMessage => Colors.cyan;
//
//   Color get alertSuccessMessage => Colors.green;
// }
//
// extension CustomTextTheme on TextTheme {
//   TextStyle get brand => GoogleFonts.nunito(
//         color: const Color(0xFFFFFFFF),
//         fontSize: 28,
//         fontWeight: FontWeight.w400,
//       );
//
//   TextStyle get credentialTitle => GoogleFonts.nunito(
//         color: const Color(0xFF424242),
//         fontSize: 14,
//         fontWeight: FontWeight.bold,
//       );
//
//   TextStyle get credentialDescription => GoogleFonts.nunito(
//         color: const Color(0xFF757575),
//         fontSize: 14,
//         fontWeight: FontWeight.bold,
//       );
//
//   TextStyle get credentialFieldTitle => GoogleFonts.nunito(
//         color: const Color(0xff212121),
//         fontSize: 12,
//         fontWeight: FontWeight.w400,
//       );
//
//   TextStyle get credentialFieldDescription => GoogleFonts.nunito(
//         color: const Color(0xff212121),
//         fontSize: 13,
//         fontWeight: FontWeight.w600,
//       );
//
//   TextStyle get learningAchievementTitle => GoogleFonts.nunito(
//         color: const Color(0xff212121),
//         fontSize: 12,
//         fontWeight: FontWeight.w600,
//       );
//
//   TextStyle get learningAchievementDescription => GoogleFonts.nunito(
//         color: const Color(0xff212121),
//         fontSize: 12,
//         fontWeight: FontWeight.w400,
//       );
//
//   TextStyle get credentialIssuer => GoogleFonts.nunito(
//         color: const Color(0xff212121),
//         fontSize: 13,
//         fontWeight: FontWeight.w500,
//       );
//
//   TextStyle get imageCard => GoogleFonts.nunito(
//         color: const Color(0xff212121),
//         fontSize: 12,
//         fontWeight: FontWeight.w500,
//       );
//
//   TextStyle get loyaltyCard => GoogleFonts.nunito(
//         color: const Color(0xffffffff),
//         fontSize: 13,
//         fontWeight: FontWeight.w600,
//       );
//
//   TextStyle get professionalExperienceAssessmentRating => GoogleFonts.nunito(
//         color: const Color(0xff212121),
//         fontSize: 13,
//         fontWeight: FontWeight.w500,
//       );
//
//   TextStyle get voucherOverlay => GoogleFonts.nunito(
//         color: const Color(0xffFFFFFF),
//         fontSize: 13,
//         fontWeight: FontWeight.w500,
//       );
//
//   TextStyle get ecole42LearningAchievementStudentIdentity => GoogleFonts.nunito(
//         color: const Color(0xff212121),
//         fontSize: 6,
//         fontWeight: FontWeight.w700,
//       );
//
//   TextStyle get ecole42LearningAchievementLevel => GoogleFonts.nunito(
//         color: const Color(0xff212121),
//         fontSize: 5,
//         fontWeight: FontWeight.w700,
//       );
// }
