import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// TODO(all): upgrade app theme to this theme

abstract class AltmeAppTheme {
  static const Color darkPrimary = Color(0xff6600FF);
  static const Color darkPrimaryContainer = Color(0xff5805D3);
  static const Color darkSecondary = Color(0xff00A1FF);
  static const Color darkSecondaryContainer = Color(0xff0492E5);
  static const Color darkSurface = Color(0xff212121);
  static const Color darkBackground = Color(0xff050114);
  static const Color darkError = Color(0xffcf6679);
  static const Color darkOnPrimary = Colors.black;
  static const Color darkOnSecondary = Colors.black;
  static const Color darkOnSurface = Color(0xffF1EFF8);
  static const Color darkOnBackground = Color(0xffB6ABDB);
  static const Color darkOnError = Colors.black;
  static Color darkShadow = const Color(0xFF1D1D1D).withOpacity(0.1);
  static Color cardColor = Colors.white.withOpacity(0.15);

  static ThemeData get darkThemeData => ThemeData(
        brightness: Brightness.dark,
        cardColor: cardColor,
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
            color: const Color(0xffF1EFF8),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          subtitle2: GoogleFonts.nunito(
            color: const Color(0xffF1EFF8),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          bodyText1: GoogleFonts.nunito(
            color: const Color(0xFF8B8C92),
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          bodyText2: GoogleFonts.nunito(
            color: const Color(0xffF1EFF8),
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          button: GoogleFonts.nunito(
            color: const Color(0xffF1EFF8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          overline: GoogleFonts.nunito(
            color: const Color(0xffF1EFF8),
            fontSize: 10,
            letterSpacing: 0,
          ),
          caption: GoogleFonts.nunito(
            color: const Color(0xffF1EFF8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xffF1EFF8)),
        snackBarTheme: snackBarThemeData,
      );

  static SnackBarThemeData get snackBarThemeData => SnackBarThemeData(
        backgroundColor: Colors.green,
        contentTextStyle: GoogleFonts.nunito(
          color: const Color(0xffF1EFF8),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      );
}

//TODO update colors
extension CustomColorScheme on ColorScheme {
  Color get transparent => Colors.transparent;

  Color get appBar => brightness == Brightness.light
      ? const Color(0xFFFFFFFF)
      : const Color(0xFF1D1D1D);

  Color get backButton => brightness == Brightness.light
      ? const Color(0xFF1D1D1D)
      : const Color(0xFFADACAC);

  Color get selectedBottomBar => brightness == Brightness.light
      ? AltmeAppTheme.darkOnSurface //AppTheme.lightOnSurface
      : AltmeAppTheme.darkOnSurface;

  Color get borderColor => brightness == Brightness.light
      ? const Color(0xFFEEEAEA)
      : const Color(0xFF3B3A3A);

  Color get markDownH1 => brightness == Brightness.light
      ? const Color(0xFFDBD8D8) //AppTheme.lightOnSurface
      : const Color(0xFFDBD8D8);

  Color get markDownH2 => brightness == Brightness.light
      ? const Color(0xFFDBD8D8) //AppTheme.lightOnSurface
      : const Color(0xFFDBD8D8);

  Color get markDownP => brightness == Brightness.light
      ? const Color(0xFFADACAC) //AppTheme.lightOnSurface
      : const Color(0xFFADACAC);

  Color get markDownA => brightness == Brightness.light
      ? const Color(0xff3700b3)
      : const Color(0xff517bff);

  Color get subtitle1 => brightness == Brightness.light
      ? const Color(0xff212121)
      : const Color(0xFFFFFFFF);

  Color get subtitle2 => brightness == Brightness.light
      ? const Color(0xff212121)
      : const Color(0xFF8B8C92);

  Color get button => brightness == Brightness.light
      ? const Color(0xff212121)
      : const Color(0xFFEEEAEA);

  Color get profileDummy => brightness == Brightness.light
      ? const Color(0xFFE0E0E0)
      : const Color(0xFF212121);

  Color get documentShadow => brightness == Brightness.light
      ? const Color(0xFF757575)
      : const Color(0xFF424242);

  Color get documentShape =>
      AltmeAppTheme.darkPrimaryContainer.withOpacity(0.05);

  Color get star => const Color(0xFFFFB83D);

  Color get genderIcon => const Color(0xFF212121);

  Color get activeCredential => Colors.green;

  Color get expiredCredential => Colors.orange;

  Color get revokedCredential => Colors.red;

  Color get snackBarError => Colors.red;

  Color get buttonDisabled => brightness == Brightness.light
      ? const Color(0xFFADACAC)
      : const Color(0xFF424242);
}

// TODO(all): update this extension styles
extension CustomTextTheme on TextTheme {
  Color get star => const Color(0xFFFFB83D);

  Color get genderIcon => const Color(0xFF212121);

  Color get activeCredential => Colors.green;

  Color get expiredCredential => Colors.orange;

  Color get revokedCredential => Colors.red;

  Color get snackBarError => Colors.red;

  TextStyle get brand => GoogleFonts.montserrat(
        color: const Color(0xFFFFFFFF),
        fontSize: 28,
        fontWeight: FontWeight.w400,
      );

  TextStyle get credentialTitle => GoogleFonts.montserrat(
        color: const Color(0xFF424242),
        fontSize: 14,
        fontWeight: FontWeight.bold,
      );

  TextStyle get credentialTitleCard => GoogleFonts.roboto(
        color: const Color(0xFFFFFFFF),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  TextStyle get credentialDescription => GoogleFonts.montserrat(
        color: const Color(0xFF757575),
        fontSize: 13,
        fontWeight: FontWeight.normal,
      );

  TextStyle get credentialTextCard => GoogleFonts.roboto(
        color: const Color(0xff212121),
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

  TextStyle get credentialFieldTitle => GoogleFonts.montserrat(
        color: const Color(0xff212121),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get credentialFieldDescription => GoogleFonts.montserrat(
        color: const Color(0xff212121),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      );

  TextStyle get learningAchievementTitle => GoogleFonts.montserrat(
        color: const Color(0xff212121),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      );

  TextStyle get learningAchievementDescription => GoogleFonts.montserrat(
        color: const Color(0xff212121),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get credentialIssuer => GoogleFonts.montserrat(
        color: const Color(0xff212121),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  TextStyle get imageCard => GoogleFonts.montserrat(
        color: const Color(0xff212121),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );

  TextStyle get loyaltyCard => GoogleFonts.montserrat(
        color: const Color(0xffffffff),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      );

  TextStyle get over18 => GoogleFonts.roboto(
        color: const Color(0xffffffff),
        fontSize: 20,
        fontWeight: FontWeight.normal,
      );

  TextStyle get professionalExperienceAssessmentRating =>
      GoogleFonts.montserrat(
        color: const Color(0xff212121),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  TextStyle get voucherOverlay => GoogleFonts.montserrat(
        color: const Color(0xffFFFFFF),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  TextStyle get ecole42LearningAchievementStudentIdentity =>
      GoogleFonts.montserrat(
        color: const Color(0xff212121),
        fontSize: 6,
        fontWeight: FontWeight.w700,
      );

  TextStyle get ecole42LearningAchievementLevel => GoogleFonts.montserrat(
        color: const Color(0xff212121),
        fontSize: 5,
        fontWeight: FontWeight.w700,
      );
}

extension ThemDataExtension on ThemeData {
  LinearGradient get darkGradient => const LinearGradient(
        colors: [Color(0xff0A0421), Color(0xff25095B)],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  LinearGradient get darkGradientReversed => const LinearGradient(
        colors: [Color(0xff0A0421), Color(0xff25095B)],
        end: Alignment.bottomCenter,
        begin: Alignment.topCenter,
      );

  LinearGradient get primaryButtonGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF6600FF),
          Color(0xFF330080),
        ],
      );

  TextStyle get starterTitleStyle => GoogleFonts.nunito(
        color: Colors.white,
        fontSize: 38,
        fontWeight: FontWeight.bold,
      );
}
