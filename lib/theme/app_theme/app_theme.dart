import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  /// A color frequently across your app’s screens and components.
  static const Color darkPrimary = Color(0XFF6600FF);

  /// A color that's clearly legible when drawn on primary
  static const Color darkOnPrimary = Colors.black;

  /// A color used for elements needing less emphasis than primary
  static const Color darkPrimaryContainer = Color(0xFFFFFFFF);

  /// An accent color used for less prominent components in the UI, such as
  /// filter chips, while expanding the opportunity for color expression.
  static const Color darkSecondary = Color(0XFF00A1FF);

  /// A color that's clearly legible when drawn on secondary
  static const Color darkOnSecondary = Colors.black;

  /// A color used for elements needing less emphasis than secondary
  static const Color darkSecondaryContainer = Color(0xFFFFFFFF);

  /// The background color for widgets like Card.
  static const Color darkSurface = Color(0xff212121);

  /// A color that's clearly legible when drawn on surface.
  static const Color darkOnSurface = Colors.white;

  /// A color that typically appears behind scrollable content.
  static const Color darkBackground = Color(0XFF0D1019);

  /// A color that's clearly legible when drawn on background.
  static const Color darkOnBackground = Colors.white;

  /// The color to use for input validation errors, e.g. for
  /// InputDecoration.errorText
  static const Color darkError = Color(0xffcf6679);

  /// A color that's clearly legible when drawn on error.
  static const Color darkOnError = Colors.black;

  static Color darkShadow = const Color(0xFF1D1D1D).withOpacity(0.1);

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
}

extension CustomColorScheme on ColorScheme {
  Color get transparent => Colors.transparent;

  Color get appBar => const Color(0xFF1D1D1D);

  Color get backButton => const Color(0xFFADACAC);

  Color get selectedBottomBar => AppTheme.darkOnSurface;

  Color get borderColor => const Color(0xFF3B3A3A);

  Color get markDownH1 => const Color(0xFFDBD8D8);

  Color get markDownH2 => const Color(0xFFDBD8D8);

  Color get markDownP => const Color(0xFFADACAC);

  Color get markDownA => const Color(0xff517bff);

  Color get subtitle1 => const Color(0xFFFFFFFF);

  Color get subtitle2 => const Color(0xFF8B8C92);

  Color get button => const Color(0xFFEEEAEA);

  Color get profileDummy => const Color(0xFF212121);

  Color get documentShadow => const Color(0xFF424242);

  Color get documentShape => const Color(0xff3700b3).withOpacity(0.5);

  Color get star => const Color(0xFFFFB83D);

  Color get genderIcon => const Color(0xFF212121);

  Color get activeCredential => Colors.green;

  Color get expiredCredential => Colors.orange;

  Color get revokedCredential => Colors.red;

  Color get buttonDisabled => const Color(0xFF424242);

  Color get alertErrorMessage => Colors.red;

  Color get alertWarningMessage => Colors.yellow;

  Color get alertInfoMessage => Colors.cyan;

  Color get alertSuccessMessage => Colors.green;

  Color get textFieldBorder => const Color(0xFFAFAFAF);

  Color get textFieldErrorBorder => Colors.red;
}

extension CustomTextTheme on TextTheme {
  TextStyle get brand => GoogleFonts.nunito(
        color: const Color(0xFFFFFFFF),
        fontSize: 28,
        fontWeight: FontWeight.w400,
      );

  TextStyle get credentialTitle => GoogleFonts.nunito(
        color: const Color(0xFF424242),
        fontSize: 14,
        fontWeight: FontWeight.bold,
      );

  TextStyle get credentialDescription => GoogleFonts.nunito(
        color: const Color(0xFF757575),
        fontSize: 14,
        fontWeight: FontWeight.bold,
      );

  TextStyle get credentialFieldTitle => GoogleFonts.nunito(
        color: const Color(0xff212121),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get credentialFieldDescription => GoogleFonts.nunito(
        color: const Color(0xff212121),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      );

  TextStyle get learningAchievementTitle => GoogleFonts.nunito(
        color: const Color(0xff212121),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      );

  TextStyle get learningAchievementDescription => GoogleFonts.nunito(
        color: const Color(0xff212121),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get credentialIssuer => GoogleFonts.nunito(
        color: const Color(0xff212121),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  TextStyle get imageCard => GoogleFonts.nunito(
        color: const Color(0xff212121),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );

  TextStyle get loyaltyCard => GoogleFonts.nunito(
        color: const Color(0xffffffff),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      );

  TextStyle get professionalExperienceAssessmentRating => GoogleFonts.nunito(
        color: const Color(0xff212121),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  TextStyle get voucherOverlay => GoogleFonts.nunito(
        color: const Color(0xffFFFFFF),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  TextStyle get ecole42LearningAchievementStudentIdentity => GoogleFonts.nunito(
        color: const Color(0xff212121),
        fontSize: 6,
        fontWeight: FontWeight.w700,
      );

  TextStyle get ecole42LearningAchievementLevel => GoogleFonts.nunito(
        color: const Color(0xff212121),
        fontSize: 5,
        fontWeight: FontWeight.w700,
      );

  TextStyle get certificateOfEmploymentTitleCard => GoogleFonts.nunito(
        color: const Color(0xFF0650C6),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  TextStyle get certificateOfEmploymentDescription => GoogleFonts.nunito(
        color: const Color(0xFF757575),
        fontSize: 13,
        fontWeight: FontWeight.normal,
      );

  TextStyle get certificateOfEmploymentData => GoogleFonts.nunito(
        color: const Color(0xFF434e62),
        fontSize: 12,
        fontWeight: FontWeight.normal,
      );

  TextStyle get credentialStudentCardTextCard => GoogleFonts.nunito(
        color: const Color(0xffffffff),
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

  TextStyle get over18 => GoogleFonts.nunito(
        color: const Color(0xffffffff),
        fontSize: 20,
        fontWeight: FontWeight.normal,
      );

  TextStyle get studentCardSchool => GoogleFonts.nunito(
        color: const Color(0xff9dc5ff),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );

  TextStyle get studentCardData => GoogleFonts.nunito(
        color: const Color(0xffffffff),
        fontSize: 12,
        fontWeight: FontWeight.normal,
      );

  TextStyle get credentialTitleCard => GoogleFonts.nunito(
        color: const Color(0xFFFFFFFF),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  TextStyle get credentialTextCard => GoogleFonts.nunito(
        color: const Color(0xff212121),
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

  TextStyle get illustrationPageDescription => GoogleFonts.nunito(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );
}
