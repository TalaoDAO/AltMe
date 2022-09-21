import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  /// A color frequently across your app’s screens and components.
  static Color darkPrimary = const Color(0xff75FD92);

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
  static Color darkSurface = const Color(0xff020D09);

  /// A color that's clearly legible when drawn on surface.
  static Color darkOnSurface = const Color(0xffEDEAF5);

  /// A color that typically appears behind scrollable content.
  static Color darkBackground = const Color(0xff020D09);

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

  static Color highlightColor = const Color(0xFF3C324C);

  static ThemeData get darkThemeData => ThemeData(
        brightness: Brightness.dark,
        dividerColor: dividerColor,
        highlightColor: highlightColor,
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
          caption: GoogleFonts.sora(
            color: const Color(0xFFFFFFFF),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          headline6: GoogleFonts.sora(
            color: const Color(0xFFFFFFFF),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          headline5: GoogleFonts.sora(
            color: const Color(0xFFFFFFFF),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          headline4: GoogleFonts.sora(
            color: const Color(0xFFFFFFFF),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xff75FD92)),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.green,
          contentTextStyle: GoogleFonts.sora(
            color: const Color(0xFFFFFFFF),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
}

extension CustomColorScheme on ColorScheme {
  Color get transactionApplied => const Color(0xFF00B267);
  Color get transactionFailed => const Color(0xFFFF0045);
  Color get transactionSkipped => const Color(0xFFFF5F0A);
  Color get activeColorOfNetwork => const Color(0xFF2C7DF7);

  Color get greyText => const Color(0xFFD1CCE3);

  Color get cardHighlighted => const Color(0xFF251F38);

  Color get defaultDialogDark => const Color(0xFF322643);

  Color get closeIconColor => const Color(0xFFA79ABA);

  Color get iconBackgroundColor => const Color(0xFF5CCA78);

  Color get kycVerifyButton => const Color(0xFF0045FF);

  Color get checkMarkColor => const Color(0xFF00B267);

  Color get accountBottomSheetBorder => Colors.grey[200]!;

  Color get digitPrimaryColor => Colors.white;

  Color get digitFillColor => Colors.transparent;

  Color get disabledBgColor => const Color(0xFF122E25);

  Color get disabledTextColor => Colors.white;

  Color get darkGradientStartColor => const Color(0xff25095B);

  Color get darkGradientEndColor => const Color(0xff25095B);

  Color get transparent => Colors.transparent;

  Color get onOutlineButton => const Color(0xFF75FD92);

  Color get onElevatedButton => Colors.black;

  Color get appBarUpperLayer => Colors.black;

  Color get appBarLowerLayer => background;

  Color get surfaceContainer => const Color(0xff707070).withOpacity(0.07);

  Color get drawerSurface => const Color(0xff020D09);

  Color get label => Colors.white;

  Color get unSelectedLabel => const Color(0xff143F32);

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

  Color get documentShape => const Color(0xff3700b3).withOpacity(0.05);

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

  Color get qrScanBackground => const Color(0xff143F32);

  Color get qrScanInnerShadow => const Color(0xff143F32).withOpacity(0.16);

  Color get qrScanOuterShadow => const Color(0xff143F32);

  Color get qrScanIconBackground => const Color(0xff143930);

  Color get dialogText => const Color(0xFF180B2B);

  Color get tabBarNotSelected => const Color(0xFF280164);

  Color get credentialBackground => const Color(0xFF0A1914);

  Color get cryptoAccountNotSelected => Colors.grey.withOpacity(0.15);

  Color get startButtonColorA => const Color(0xff75FD92);

  Color get startButtonColorB => const Color(0xff75FD92);

  Color get associatedWalletBorder => const Color(0xff524B67);

  Color get deleteColor => const Color(0xff322643);

  Color get titleColor => const Color(0xffD1CCE3);

  Color get valueColor => const Color(0xffFFFFFF);

  Color get lightGrey => const Color(0xFF616161);

  Color get darkGrey => const Color(0xFF212121);

  Color get activeColor => const Color(0xFF08B530);

  Color get inactiveColor => const Color(0xFFFF0045);

  Color get beaconBorder => const Color(0xff86809D);

  Color get cardBackground => const Color(0xFF211F33);
}

extension CustomTextTheme on TextTheme {
  TextStyle get hintTextFieldStyle => GoogleFonts.sora(
        fontSize: 14,
        height: 1.5,
        letterSpacing: 1.02,
        fontWeight: FontWeight.normal,
        color: const Color(0xffD1CCE3),
      );

  TextStyle get keyboardDigitTextStyle =>
      GoogleFonts.sora(fontSize: 30, color: Colors.white);

  TextStyle get calculatorKeyboardDigitTextStyle => GoogleFonts.sora(
        fontSize: 30,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      );

  TextStyle get keyboardDeleteButtonTextStyle =>
      GoogleFonts.sora(fontSize: 16, color: Colors.white);

  TextStyle get loadingText => GoogleFonts.sora(
        color: const Color(0xFFFFFFFF),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  TextStyle get starterTitleStyle => GoogleFonts.sora(
        color: const Color(0xFFFFFFFF),
        fontSize: 32,
        fontWeight: FontWeight.w600,
      );

  TextStyle get starterSubTitleStyle => GoogleFonts.sora(
        color: const Color(0xFFD1CCE3),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get onBoardingTitleStyle => GoogleFonts.sora(
        color: const Color(0xFFFFFFFF),
        fontSize: 22,
        fontWeight: FontWeight.w600,
      );

  TextStyle get onBoardingSubTitleStyle => GoogleFonts.sora(
        color: const Color(0xFFD1CCE3),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get learnMoreTextStyle => GoogleFonts.sora(
        color: const Color(0xFFD1CCE3),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        decoration: TextDecoration.underline,
      );

  TextStyle get infoTitle => GoogleFonts.sora(
        color: const Color(0xFFEDEAF5),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  TextStyle get infoSubtitle => GoogleFonts.sora(
        color: const Color(0xFFD1CCE3),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get normal => GoogleFonts.sora(
        color: const Color(0xFFD1CCE3),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get appBar => GoogleFonts.sora(
        color: const Color(0xFFFFFFFF),
        fontSize: 24,
        fontWeight: FontWeight.w800,
      );

  TextStyle get bottomBar => GoogleFonts.sora(
        color: const Color(0xFFFFFFFF),
        fontSize: 10,
        fontWeight: FontWeight.w600,
      );

  TextStyle get title => GoogleFonts.sora(
        color: const Color(0xFFFFFFFF),
        fontSize: 18,
        fontWeight: FontWeight.w800,
      );

  TextStyle get listTitle => GoogleFonts.sora(
        color: const Color(0xFFEDEAF5),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  TextStyle get listSubtitle => GoogleFonts.sora(
        color: const Color(0xFFEDEAF5),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  TextStyle get caption2 => GoogleFonts.sora(
        color: const Color(0xFF8682A8),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get listTileTitle => GoogleFonts.sora(
        color: const Color(0xFFFFFFFF),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  TextStyle get listTileSubtitle => GoogleFonts.sora(
        color: const Color(0xFF8682A8),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get close => GoogleFonts.sora(
        color: const Color(0xFFD6C3F2),
        fontSize: 13,
        fontWeight: FontWeight.w400,
      );

  TextStyle get dialogClose => GoogleFonts.sora(
        color: const Color(0xFFA79ABA),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get drawerMenu => GoogleFonts.sora(
        color: const Color(0xFFD1CCE3),
        fontSize: 15,
        fontWeight: FontWeight.w400,
      );

  TextStyle get drawerItem => GoogleFonts.sora(
        color: const Color(0xFFFFFFFF),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  TextStyle get biometricMessage => GoogleFonts.sora(
        color: const Color(0xFFB1ADC3),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get pinCodeTitle => GoogleFonts.sora(
        color: const Color(0xFFFFFFFF),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  TextStyle get pinCodeMessage => GoogleFonts.sora(
        color: const Color(0xFFFFFFFF),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  TextStyle get getCardsButton => GoogleFonts.sora(
        color: const Color(0xFF000000),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      );

  TextStyle get miniButton => GoogleFonts.sora(
        color: const Color(0xFFFFFFFF),
        fontSize: 11,
        fontWeight: FontWeight.w500,
      );

  TextStyle get credentialTitle => GoogleFonts.sora(
        color: const Color(0xFF424242),
        fontSize: 15,
        fontWeight: FontWeight.bold,
      );

  TextStyle get credentialDescription => GoogleFonts.sora(
        color: const Color(0xFF757575),
        fontSize: 13,
        fontWeight: FontWeight.w400,
      );

  TextStyle get credentialFieldTitle => GoogleFonts.sora(
        color: const Color(0xff212121),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get credentialFieldDescription => GoogleFonts.sora(
        color: const Color(0xff212121),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      );

  TextStyle get learningAchievementTitle => GoogleFonts.sora(
        color: const Color(0xff212121),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      );

  TextStyle get learningAchievementDescription => GoogleFonts.sora(
        color: const Color(0xff212121),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get credentialIssuer => GoogleFonts.sora(
        color: const Color(0xff212121),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  TextStyle get imageCard => GoogleFonts.sora(
        color: const Color(0xff212121),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );

  TextStyle get loyaltyCard => GoogleFonts.sora(
        color: const Color(0xffffffff),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      );

  TextStyle get professionalExperienceAssessmentRating => GoogleFonts.sora(
        color: const Color(0xff212121),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  TextStyle get voucherOverlay => GoogleFonts.sora(
        color: const Color(0xffFFFFFF),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  TextStyle get ecole42LearningAchievementStudentIdentity => GoogleFonts.sora(
        color: const Color(0xff212121),
        fontSize: 6,
        fontWeight: FontWeight.w700,
      );

  TextStyle get ecole42LearningAchievementLevel => GoogleFonts.sora(
        color: const Color(0xff212121),
        fontSize: 5,
        fontWeight: FontWeight.w700,
      );

  TextStyle get certificateOfEmploymentTitleCard => GoogleFonts.sora(
        color: const Color(0xFF0650C6),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  TextStyle get certificateOfEmploymentDescription => GoogleFonts.sora(
        color: const Color(0xFF757575),
        fontSize: 13,
        fontWeight: FontWeight.normal,
      );

  TextStyle get certificateOfEmploymentData => GoogleFonts.sora(
        color: const Color(0xFF434e62),
        fontSize: 12,
        fontWeight: FontWeight.normal,
      );

  TextStyle get identityCardData => GoogleFonts.sora(
        color: const Color(0xFFFFFFFF),
        fontSize: 12,
        fontWeight: FontWeight.normal,
      );

  TextStyle get tezosAssociatedAddressData => GoogleFonts.sora(
        color: const Color(0xff605A71),
        fontSize: 17,
        fontWeight: FontWeight.normal,
      );

  TextStyle get tezosAssociatedAddressTitleCard => GoogleFonts.sora(
        color: const Color(0xffFAFDFF),
        fontSize: 20,
        fontWeight: FontWeight.w700,
      );

  TextStyle get credentialStudentCardTextCard => GoogleFonts.sora(
        color: const Color(0xffffffff),
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

  TextStyle get over18 => GoogleFonts.sora(
        color: const Color(0xffffffff),
        fontSize: 20,
        fontWeight: FontWeight.normal,
      );

  TextStyle get studentCardSchool => GoogleFonts.sora(
        color: const Color(0xff9dc5ff),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );

  TextStyle get studentCardData => GoogleFonts.sora(
        color: const Color(0xffffffff),
        fontSize: 12,
        fontWeight: FontWeight.normal,
      );

  TextStyle get credentialTitleCard => GoogleFonts.sora(
        color: const Color(0xFFFFFFFF),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  TextStyle get voucherValueCard => GoogleFonts.sora(
        color: const Color(0xFFFEEA00),
        fontSize: 50,
        fontWeight: FontWeight.bold,
      );

  TextStyle get credentialTextCard => GoogleFonts.sora(
        color: const Color(0xff212121),
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

  TextStyle get illustrationPageDescription => GoogleFonts.sora(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  TextStyle get dialogTitle => GoogleFonts.sora(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  TextStyle get dialogSubtitle => GoogleFonts.sora(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Colors.white.withOpacity(0.67),
      );

  TextStyle get walletAltme => GoogleFonts.sora(
        fontSize: 25,
        fontWeight: FontWeight.w600,
        color: const Color(0xff180B2B),
      );

  TextStyle get finishVerificationDialogTitle => GoogleFonts.sora(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: const Color(0xff180B2B),
      );

  TextStyle get finishVerificationDialogBody => GoogleFonts.sora(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF5F556F),
      );

  TextStyle get defaultDialogTitle => GoogleFonts.sora(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: const Color(0xff180B2B),
      );

  TextStyle get defaultDialogBody => GoogleFonts.sora(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF5F556F),
      );

  TextStyle get kycDialogTitle => GoogleFonts.sora(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: const Color(0xff180B2B),
      );

  TextStyle get kycDialogCaption => GoogleFonts.sora(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF0045FF),
      );

  TextStyle get kycDialogBody => GoogleFonts.sora(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF180B2B),
      );

  TextStyle get kycDialogFooter => GoogleFonts.sora(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF180B2B),
      );

  TextStyle get walletAltmeMessage => GoogleFonts.sora(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xff9A8BB1),
      );

  TextStyle get credentialCategoryTitle => GoogleFonts.sora(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: const Color(0xffEDEAF5),
      );

  TextStyle get credentialSurfaceText => GoogleFonts.sora(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: const Color(0xff00B267),
      );

  TextStyle get errorMessage => GoogleFonts.sora(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: const Color(0xffFFFFFF),
      );

  TextStyle get accountsText => GoogleFonts.sora(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: const Color(0xffFFFFFF),
      );

  TextStyle get accountsName => GoogleFonts.sora(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: const Color(0xffFFFFFF),
      );

  TextStyle get accountsListItemTitle => GoogleFonts.sora(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: const Color(0xffFFFFFF),
      );

  TextStyle get walletAddress => GoogleFonts.sora(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF757575),
      );

  TextStyle get textButton => GoogleFonts.sora(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: const Color(0xff75FD92),
      );

  TextStyle get scrollText => GoogleFonts.sora(
        fontSize: 9,
        fontWeight: FontWeight.w500,
        color: const Color(0xffFFFFFF),
      );

  TextStyle get passPhraseText => GoogleFonts.sora(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xffD1CCE3),
      );

  TextStyle get message => GoogleFonts.sora(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: const Color(0xffEDEAF5),
      );

  TextStyle get subMessage => GoogleFonts.sora(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: const Color(0xff71CBFF),
      );

  TextStyle get identitiyBaseSmallText => GoogleFonts.sora(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: const Color(0xffFFFFFF),
      );
  TextStyle get identitiyBaseMediumBoldText => GoogleFonts.sora(
        fontSize: 21,
        fontWeight: FontWeight.w500,
        color: const Color(0xffFFFFFF),
      );

  TextStyle get copyToClipBoard => GoogleFonts.sora(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xffDED6EA),
        decoration: TextDecoration.underline,
      );

  TextStyle get onBoardingCheckMessage => GoogleFonts.sora(
        fontSize: 15,
        height: 1.5,
        fontWeight: FontWeight.w600,
        color: const Color(0xffFFFFFF),
      );

  TextStyle get messageTitle => GoogleFonts.sora(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: const Color(0xffEDEAF5),
      );

  TextStyle get messageSubtitle => GoogleFonts.sora(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xffEDEAF5),
      );

  TextStyle get radioTitle => GoogleFonts.sora(
        color: const Color(0xFFFFFFFF),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  TextStyle get radioOption => GoogleFonts.sora(
        color: const Color(0xFFFFFFFF),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get credentialManifestTitle1 => GoogleFonts.sora(
        color: const Color(0xffFFFFFF),
        fontSize: 18,
        fontWeight: FontWeight.w700,
      );

  TextStyle get credentialManifestDescription => GoogleFonts.sora(
        color: const Color(0xffFFFFFF),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get credentialManifestTitle2 => GoogleFonts.sora(
        color: const Color(0xffFFFFFF),
        fontSize: 16,
        fontWeight: FontWeight.w700,
      );

  TextStyle get credentialSubtitle => GoogleFonts.sora(
        color: const Color(0xffFFFFFF),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  TextStyle get credentialStatus => GoogleFonts.sora(
        color: const Color(0xffFFFFFF),
        fontSize: 18,
        fontWeight: FontWeight.w800,
      );

  TextStyle get beaconRequestPermission => GoogleFonts.sora(
        color: const Color(0xff86809D),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get beaconSelectAccont => GoogleFonts.sora(
        color: const Color(0xffFFFFFF),
        fontSize: 18,
        fontWeight: FontWeight.w800,
      );

  TextStyle get beaconPermissionTitle => GoogleFonts.sora(
        color: const Color(0xffFFFFFF),
        fontSize: 18,
        fontWeight: FontWeight.w800,
      );

  TextStyle get beaconPermissions => GoogleFonts.sora(
        color: const Color(0xffFFFFFF),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get beaconPayload => GoogleFonts.sora(
        color: const Color(0xffFFFFFF),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );
}
