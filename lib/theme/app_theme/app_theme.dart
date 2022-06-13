import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  /// A color frequently across your app’s screens and components.
  static Color darkPrimary = const Color(0xff6600FF);

  /// A color that's clearly legible when drawn on primary
  static Color darkOnPrimary = const Color(0xffFFFFFF);

  /// An accent color used for less prominent components in the UI, such as
  /// filter chips, while expanding the opportunity for color expression.
  static Color darkSecondary = const Color(0xff00A1FF);

  /// A color that's clearly legible when drawn on secondary
  static Color darkOnSecondary = const Color(0xffFFFFFF);

  /// A color used as a contrasting accent that can balance primary
  /// and secondary colors or bring heightened attention to an element,
  /// such as an input field.
  static Color darkTertiary = const Color(0xffFFFFFF);

  /// A color that's clearly legible when drawn on tertiary.
  static Color darkOnTertiary = const Color(0xffD1CCE3);

  /// The background color for widgets like Card.
  static Color darkSurface = const Color(0xff1A182D);

  /// A color that's clearly legible when drawn on surface.
  static Color darkOnSurface = const Color(0xffEDEAF5);

  /// A color that typically appears behind scrollable content.
  static Color darkBackground = const Color(0xff0D1019);

  /// A color that's clearly legible when drawn on background.
  static Color darkOnBackground = const Color(0xffFFFFFF);

  /// The color to use for input validation errors, e.g. for
  /// InputDecoration.errorText
  static const Color darkError = Color(0xffcf6679);

  /// A color that's clearly legible when drawn on error.
  static const Color darkOnError = Colors.black;

  /// A color use to paint the drop shadows of elevated components.
  static Color darkShadow = const Color(0xff1D1D1D).withOpacity(0.1);

  static ThemeData get darkThemeData => ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme(
          primary: darkPrimary,
          onPrimary: darkOnPrimary,
          secondary: darkSecondary,
          onSecondary: darkOnSecondary,
          tertiary: darkTertiary,
          onTertiary: darkOnTertiary,
          surface: darkSurface,
          onSurface: darkOnSurface,
          background: darkBackground,
          onBackground: darkOnBackground,
          error: darkError,
          onError: darkOnError,
          shadow: darkShadow,
          brightness: Brightness.dark,
        ),
        textTheme: TextTheme(
          caption: GoogleFonts.nunito(
            color: const Color(0xFFFFFFFF),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xff6600FF)),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.green,
          contentTextStyle: GoogleFonts.nunito(
            color: const Color(0xFFFFFFFF),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
}

extension CustomColorScheme on ColorScheme {
  Color get digitPrimaryColor => Colors.white;
  Color get digitFillColor => Colors.transparent;

  Color get darkGradientStartColor => const Color(0xff0A0421);

  Color get darkGradientEndColor => const Color(0xff25095B);

  Color get transparent => Colors.transparent;

  Color get onOutlineButton => const Color(0xFF6600FF);

  Color get onElevatedButton => const Color(0xFFFFFFFF);

  Color get appBarUpperLayer => background.withOpacity(0.5);

  Color get appBarLowerLayer => background;

  Color get surfaceContainer => const Color(0xff707070).withOpacity(0.07);

  Color get label => Colors.white;

  Color get unSelectedLabel => const Color(0xff86809D);

  Color get leadingButton => const Color(0xffF1EFF8);

  Color get selectedBottomBar => surface;

  Color get drawerBackground => const Color(0xff0B0E19);

  Color get borderColor => const Color(0xFFDDCEF4);

  Color get markDownH1 => const Color(0xFFDBD8D8);

  Color get markDownH2 => const Color(0xFFDBD8D8);

  Color get markDownP => const Color(0xFFADACAC);

  Color get markDownA => const Color(0xff517bff);

  Color get subtitle1 => const Color(0xFFFFFFFF);

  Color get subtitle2 => const Color(0xFF8B8C92);

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

  Color get qrScanBackground => const Color(0xff2B1C48);

  Color get qrScanInnerShadow => const Color(0xff000000).withOpacity(0.16);

  Color get qrScanOuterShadow => const Color(0xff430F91);

  Color get dialogText => const Color(0xFF8682A8);

  Color get tabBarNotSelected => const Color(0xFF280164);

  Color get credentialBackground => const Color(0xFF211F33);
}

extension CustomTextTheme on TextTheme {
  TextStyle get keyboardDigitTextStyle =>
      GoogleFonts.nunito(fontSize: 30, color: Colors.white);

  TextStyle get keyboardDeleteButtonTextStyle =>
      GoogleFonts.nunito(fontSize: 16, color: Colors.white);

  TextStyle get starterTitleStyle => GoogleFonts.nunito(
        color: const Color(0xFFEDEAF5),
        fontSize: 28,
        fontWeight: FontWeight.w800,
      );

  TextStyle get starterSubTitleStyle => GoogleFonts.nunito(
        color: const Color(0xFFD1CCE3),
        fontSize: 22,
        fontWeight: FontWeight.w500,
      );

  TextStyle get infoTitle => GoogleFonts.nunito(
        color: const Color(0xFFEDEAF5),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  TextStyle get infoSubtitle => GoogleFonts.nunito(
        color: const Color(0xFFD1CCE3),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get normal => GoogleFonts.nunito(
        color: const Color(0xFFD1CCE3),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get appBar => GoogleFonts.nunito(
        color: const Color(0xFFFFFFFF),
        fontSize: 24,
        fontWeight: FontWeight.w800,
      );

  TextStyle get bottomBar => GoogleFonts.nunito(
        color: const Color(0xFFFFFFFF),
        fontSize: 10,
        fontWeight: FontWeight.w600,
      );

  TextStyle get listTitle => GoogleFonts.nunito(
        color: const Color(0xFFEDEAF5),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  TextStyle get listSubtitle => GoogleFonts.nunito(
        color: const Color(0xFFEDEAF5),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  TextStyle get caption2 => GoogleFonts.nunito(
        color: const Color(0xFF8682A8),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get listTileTitle => GoogleFonts.nunito(
        color: const Color(0xFFFFFFFF),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  TextStyle get listTileSubtitle => GoogleFonts.nunito(
        color: const Color(0xFF8682A8),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get close => GoogleFonts.nunito(
        color: const Color(0xFFD6C3F2),
        fontSize: 13,
        fontWeight: FontWeight.w400,
      );

  TextStyle get drawerItem => GoogleFonts.nunito(
        color: const Color(0xFFFFFFFF),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  TextStyle get pinCodeTitle => GoogleFonts.nunito(
        color: const Color(0xFFFFFFFF),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  TextStyle get getCardsButton => GoogleFonts.nunito(
        color: const Color(0xFFFFFFFF),
        fontSize: 12,
        fontWeight: FontWeight.w600,
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

  TextStyle get associatedWalletData => GoogleFonts.nunito(
        color: const Color(0xffeee7e7),
        fontSize: 12,
        fontWeight: FontWeight.normal,
      );

  TextStyle get associatedWalletTitleCard => GoogleFonts.nunito(
        color: const Color(0xffeee7e7),
        fontSize: 20,
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

  TextStyle get dialogTitle => GoogleFonts.nunito(
        fontSize: 17,
        fontWeight: FontWeight.w600,
      );

  TextStyle get dialogSubtitle => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  TextStyle get credentialCategoryTitle => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: const Color(0xffEDEAF5),
      );

  TextStyle get credentialSurfaceText => GoogleFonts.nunito(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: const Color(0xff00B267),
      );

  TextStyle get errorMessage => GoogleFonts.nunito(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: const Color(0xffFFFFFF),
      );
}
