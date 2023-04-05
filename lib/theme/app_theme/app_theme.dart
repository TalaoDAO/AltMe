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
      );
}

extension CustomColorScheme on ColorScheme {
  Color get redColor => const Color(0xFFFF0045);
  Color get transactionApplied => const Color(0xFF00B267);
  Color get transactionFailed => const Color(0xFFFF0045);
  Color get transactionSkipped => const Color(0xFFFF5F0A);
  Color get activeColorOfNetwork => const Color(0xFF2C7DF7);

  Color get greyText => const Color(0xFFD1CCE3);

  Color get kycKeyIconColor => const Color(0xFF86809D);

  Color get popupBackground => const Color(0xff271C38);

  Color get cardHighlighted => const Color(0xFF251F38);

  Color get defaultDialogDark => const Color(0xFF322643);

  Color get closeIconColor => const Color(0xFFA79ABA);

  Color get kycVerifyButton => const Color(0xFF0045FF);

  Color get checkMarkColor => const Color(0xFF00B267);

  Color get accountBottomSheetBorder => Colors.grey[200]!;

  Color get digitPrimaryColor => Colors.white;

  Color get digitFillColor => Colors.transparent;

  Color get disabledBgColor => const Color(0xFF6A5F7B);

  Color get disabledTextColor => const Color(0xFF000000);

  Color get darkGradientStartColor => const Color(0xff0A0F19);

  Color get darkGradientEndColor => const Color(0xff25095B);

  Color get transparent => Colors.transparent;

  Color get onOutlineButton => const Color(0xFF6600FF);

  Color get onElevatedButton => const Color(0xFFFFFFFF);

  Color get appBarUpperLayer => const Color(0xff25095B);

  Color get appBarLowerLayer => background;

  Color get surfaceContainer => const Color(0xff707070).withOpacity(0.07);

  Color get drawerSurface => const Color(0xff232630);

  Color get label => Colors.white;

  Color get unSelectedLabel => const Color(0xff86809D);

  Color get leadingButton => const Color(0xffF1EFF8);

  Color get selectedBottomBar => surface;

  Color get drawerBackground => const Color(0xff0B0514);

  Color get borderColor => const Color(0xFFDDCEF4);

  Color get defualtDialogCancelButtonBorderColor => const Color(0xFF424052);

  Color get markDownH1 => const Color(0xFFFFFFFF);

  Color get markDownH2 => const Color(0xFFFFFFFF);

  Color get markDownP => const Color(0xFFD1CCE3);

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

  Color get qrScanBackground => const Color(0xff2B1C48);

  Color get qrScanInnerShadow => const Color(0xff000000).withOpacity(0.16);

  Color get qrScanOuterShadow => const Color(0xff430F91);

  Color get dialogText => const Color(0xffF5F5F5);

  Color get tabBarNotSelected => const Color(0xFF280164);

  Color get credentialBackground => const Color(0xFF211F33);

  Color get cryptoAccountNotSelected => Colors.grey.withOpacity(0.15);

  Color get startButtonColorA => const Color(0xff18ACFF);

  Color get startButtonColorB => const Color(0xff6600FF);

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
  TextStyle get hintTextFieldStyle => GoogleFonts.nunito(
        fontSize: 14,
        height: 1.5,
        letterSpacing: 1.02,
        fontWeight: FontWeight.normal,
        color: const Color(0xffD1CCE3),
      );

  TextStyle get keyboardDigitTextStyle =>
      GoogleFonts.roboto(fontSize: 30, color: Colors.white);

  TextStyle get calculatorKeyboardDigitTextStyle => GoogleFonts.roboto(
        fontSize: 30,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      );

  TextStyle get keyboardDeleteButtonTextStyle =>
      GoogleFonts.roboto(fontSize: 16, color: Colors.white);

  TextStyle get loadingText => GoogleFonts.roboto(
        color: const Color(0xFFFFFFFF),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  TextStyle get starterTitleStyle => GoogleFonts.nunito(
        color: const Color(0xFFFFFFFF),
        fontSize: 34,
        fontWeight: FontWeight.w700,
      );

  TextStyle get subtitle3 => GoogleFonts.nunito(
        color: const Color(0xFF86809D),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ).copyWith(height: 1.4);

  TextStyle get customListTileTitleStyle => GoogleFonts.nunito(
        color: const Color(0xFFFFFFFF),
        fontSize: 18,
        fontWeight: FontWeight.w800,
      );

  TextStyle get customListTileSubTitleStyle => GoogleFonts.nunito(
        color: const Color(0xFF86809D),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get starterSubTitleStyle => GoogleFonts.nunito(
        color: const Color(0xFFEEEEEE),
        fontSize: 26,
        fontWeight: FontWeight.w600,
      );

  TextStyle get badgeStyle => GoogleFonts.nunito(
        color: const Color(0xFFEEEEEE),
        fontSize: 8,
        fontWeight: FontWeight.w500,
      );

  TextStyle get onBoardingTitleStyle => GoogleFonts.roboto(
        color: const Color(0xFFFFFFFF),
        fontSize: 22,
        fontWeight: FontWeight.w600,
      );

  TextStyle get onBoardingSubTitleStyle => GoogleFonts.roboto(
        color: const Color(0xFFD1CCE3),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get learnMoreTextStyle => GoogleFonts.roboto(
        color: const Color(0xFFD1CCE3),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        decoration: TextDecoration.underline,
      );

  TextStyle get infoTitle => GoogleFonts.roboto(
        color: const Color(0xFFEDEAF5),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  TextStyle get infoSubtitle => GoogleFonts.roboto(
        color: const Color(0xFFD1CCE3),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get normal => GoogleFonts.roboto(
        color: const Color(0xFFD1CCE3),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get appBar => GoogleFonts.nunito(
        color: const Color(0xFFFFFFFF),
        fontSize: 24,
        fontWeight: FontWeight.w800,
      );

  TextStyle get bottomBar => GoogleFonts.roboto(
        color: const Color(0xFFFFFFFF),
        fontSize: 10,
        fontWeight: FontWeight.w600,
      );

  TextStyle get title => GoogleFonts.nunito(
        color: const Color(0xFFFFFFFF),
        fontSize: 18,
        fontWeight: FontWeight.w800,
      );

  TextStyle get listTitle => GoogleFonts.roboto(
        color: const Color(0xFFEDEAF5),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  TextStyle get listSubtitle => GoogleFonts.roboto(
        color: const Color(0xFFEDEAF5),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  TextStyle get bodySmall2 => GoogleFonts.roboto(
        color: const Color(0xFF8682A8),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get bodySmall3 => GoogleFonts.nunito(
        color: const Color(0xFF86809D),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get listTileTitle => GoogleFonts.roboto(
        color: const Color(0xFFFFFFFF),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  TextStyle get listTileSubtitle => GoogleFonts.roboto(
        color: const Color(0xFF8682A8),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get close => GoogleFonts.roboto(
        color: const Color(0xFFD6C3F2),
        fontSize: 13,
        fontWeight: FontWeight.w400,
      );

  TextStyle get dialogClose => GoogleFonts.roboto(
        color: const Color(0xFFA79ABA),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get drawerMenu => GoogleFonts.roboto(
        color: const Color(0xFFD1CCE3),
        fontSize: 15,
        fontWeight: FontWeight.w400,
      );

  TextStyle get drawerItem => GoogleFonts.nunito(
        color: const Color(0xFFFFFFFF),
        fontSize: 16,
        fontWeight: FontWeight.w700,
      );

  TextStyle get drawerCategoryTitle => GoogleFonts.nunito(
        color: const Color(0xFFFFFFFF),
        fontSize: 18,
        fontWeight: FontWeight.w800,
      );

  TextStyle get resetWalletTitle => GoogleFonts.nunito(
        color: const Color(0xFFFFFFFF),
        fontSize: 16,
        fontWeight: FontWeight.w700,
      );
  TextStyle get resetWalletSubtitle => GoogleFonts.nunito(
        color: const Color(0xFFFFFFFF),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );
  TextStyle get subtitle4 => GoogleFonts.nunito(
        color: const Color(0xFF00A1FF),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  TextStyle get drawerCategorySubTitle => GoogleFonts.nunito(
        color: const Color(0xFFD1CCE3),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get biometricMessage => GoogleFonts.roboto(
        color: const Color(0xFFB1ADC3),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get pinCodeTitle => GoogleFonts.nunito(
        color: const Color(0xFFFFFFFF),
        fontSize: 20,
        fontWeight: FontWeight.w700,
      );

  TextStyle get pinCodeMessage => GoogleFonts.nunito(
        color: const Color(0xFFFFFFFF),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  TextStyle get getCardsButton => GoogleFonts.roboto(
        color: const Color(0xFFFFFFFF),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      );

  TextStyle get miniButton => GoogleFonts.nunito(
        color: const Color(0xFFFFFFFF),
        fontSize: 11,
        fontWeight: FontWeight.w500,
      );

  TextStyle get credentialTitle => GoogleFonts.roboto(
        color: const Color(0xFF424242),
        fontSize: 15,
        fontWeight: FontWeight.bold,
      );

  TextStyle get credentialDescription => GoogleFonts.roboto(
        color: const Color(0xFF757575),
        fontSize: 13,
        fontWeight: FontWeight.w400,
      );

  TextStyle get polygonCardDetail => GoogleFonts.roboto(
        color: const Color(0xffFFFFFF),
        fontSize: 13,
        fontWeight: FontWeight.w400,
      );

  TextStyle get credentialFieldTitle => GoogleFonts.roboto(
        color: const Color(0xff212121),
        fontSize: 14,
        fontWeight: FontWeight.w800,
      );

  TextStyle get credentialFieldDescription => GoogleFonts.roboto(
        color: const Color(0xff212121),
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w400,
      );

  TextStyle get discoverFieldTitle => GoogleFonts.roboto(
        color: const Color(0xffD1CCE3),
        fontSize: 14,
        fontWeight: FontWeight.w800,
      );

  TextStyle get discoverFieldDescription => GoogleFonts.roboto(
        color: const Color(0xffFFFFFF),
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w400,
      );

  TextStyle get learningAchievementTitle => GoogleFonts.roboto(
        color: const Color(0xff212121),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      );

  TextStyle get learningAchievementDescription => GoogleFonts.roboto(
        color: const Color(0xff212121),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get credentialIssuer => GoogleFonts.roboto(
        color: const Color(0xff212121),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  TextStyle get imageCard => GoogleFonts.roboto(
        color: const Color(0xff212121),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );

  TextStyle get loyaltyCard => GoogleFonts.roboto(
        color: const Color(0xffffffff),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      );

  TextStyle get professionalExperienceAssessmentRating => GoogleFonts.roboto(
        color: const Color(0xff212121),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  TextStyle get voucherOverlay => GoogleFonts.roboto(
        color: const Color(0xffFFFFFF),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  TextStyle get ecole42LearningAchievementStudentIdentity => GoogleFonts.roboto(
        color: const Color(0xff212121),
        fontSize: 6,
        fontWeight: FontWeight.w700,
      );

  TextStyle get ecole42LearningAchievementLevel => GoogleFonts.roboto(
        color: const Color(0xff212121),
        fontSize: 5,
        fontWeight: FontWeight.w700,
      );

  TextStyle get certificateOfEmploymentTitleCard => GoogleFonts.roboto(
        color: const Color(0xFF0650C6),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  TextStyle get certificateOfEmploymentDescription => GoogleFonts.roboto(
        color: const Color(0xFF757575),
        fontSize: 13,
        fontWeight: FontWeight.normal,
      );

  TextStyle get certificateOfEmploymentData => GoogleFonts.roboto(
        color: const Color(0xFF434e62),
        fontSize: 12,
        fontWeight: FontWeight.normal,
      );

  TextStyle get identityCardData => GoogleFonts.roboto(
        color: const Color(0xFFFFFFFF),
        fontSize: 12,
        fontWeight: FontWeight.normal,
      );

  TextStyle get tezosAssociatedAddressData => GoogleFonts.roboto(
        color: const Color(0xff605A71),
        fontSize: 17,
        fontWeight: FontWeight.normal,
      );

  TextStyle get tezosAssociatedAddressTitleCard => GoogleFonts.nunito(
        color: const Color(0xffFAFDFF),
        fontSize: 20,
        fontWeight: FontWeight.w700,
      );

  TextStyle get credentialStudentCardTextCard => GoogleFonts.roboto(
        color: const Color(0xffffffff),
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

  TextStyle get over18 => GoogleFonts.roboto(
        color: const Color(0xffffffff),
        fontSize: 20,
        fontWeight: FontWeight.normal,
      );

  TextStyle get studentCardSchool => GoogleFonts.roboto(
        color: const Color(0xff9dc5ff),
        fontSize: 15,
        fontWeight: FontWeight.bold,
      );

  TextStyle get studentCardData => GoogleFonts.roboto(
        color: const Color(0xffffffff),
        fontSize: 12,
        fontWeight: FontWeight.normal,
      );

  TextStyle get credentialTitleCard => GoogleFonts.roboto(
        color: const Color(0xFFFFFFFF),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  TextStyle get voucherValueCard => GoogleFonts.roboto(
        color: const Color(0xFFFEEA00),
        fontSize: 50,
        fontWeight: FontWeight.bold,
      );

  TextStyle get credentialTextCard => GoogleFonts.roboto(
        color: const Color(0xff212121),
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

  TextStyle get illustrationPageDescription => GoogleFonts.roboto(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  TextStyle get defaultDialogTitle => GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: const Color(0xffF5F5F5),
      );

  TextStyle get defaultDialogBody => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF86809D),
      );

  TextStyle get defaultDialogSubtitle => GoogleFonts.nunito(
        fontSize: 18,
        color: const Color(0xff86809D),
      );

  TextStyle get newVersionTitle => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: const Color(0xFFFFFFFF),
      );

  TextStyle get kycDialogTitle => GoogleFonts.nunito(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: const Color(0xffF5F5F5),
      );

  TextStyle get kycDialogBodySmall => GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF0045FF),
      );

  TextStyle get kycDialogBody => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: const Color(0xff86809D),
      );

  TextStyle get kycDialogFooter => GoogleFonts.nunito(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: const Color(0xff86809D),
      );

  TextStyle get credentialCategoryTitle => GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: const Color(0xffEDEAF5),
      );

  TextStyle get credentialCategorySubTitle => GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: const Color(0xFF86809D),
      );

  TextStyle get credentialSurfaceText => GoogleFonts.roboto(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: const Color(0xff00B267),
      );

  TextStyle get errorMessage => GoogleFonts.roboto(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: const Color(0xffFFFFFF),
      );

  TextStyle get accountsText => GoogleFonts.roboto(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: const Color(0xffFFFFFF),
      );

  TextStyle get accountsName => GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: const Color(0xffFFFFFF),
      );

  TextStyle get accountsListItemTitle => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: const Color(0xffFFFFFF),
      );

  TextStyle get walletAddress => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF757575),
      );

  TextStyle get textButton => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: const Color(0xff6600FF),
      );

  TextStyle get scrollText => GoogleFonts.roboto(
        fontSize: 9,
        fontWeight: FontWeight.w500,
        color: const Color(0xffFFFFFF),
      );

  TextStyle get passPhraseText => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xffD1CCE3),
      );

  TextStyle get message => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: const Color(0xffEDEAF5),
      );

  TextStyle get subMessage => GoogleFonts.nunito(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: const Color(0xff71CBFF),
      );

  TextStyle get genPhraseSubmessage => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: const Color(0xff71CBFF),
      );

  TextStyle get pheaseVerifySubmessage => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: const Color(0xff86809D),
      );

  TextStyle get identitiyBaseLightText => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: const Color(0xffFFFFFF),
      );
  TextStyle get identitiyBaseBoldText => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: const Color(0xffFFFFFF),
      );

  TextStyle get copyToClipBoard => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: const Color(0xffDED6EA),
        decoration: TextDecoration.underline,
      );

  TextStyle get onBoardingCheckMessage => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: const Color(0xFFFFFFFF),
      );

  TextStyle get messageTitle => GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: const Color(0xffEDEAF5),
      );

  TextStyle get messageSubtitle => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xffEDEAF5),
      );

  TextStyle get radioTitle => GoogleFonts.nunito(
        color: const Color(0xFFFFFFFF),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  TextStyle get radioOption => GoogleFonts.nunito(
        color: const Color(0xFFFFFFFF),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get credentialManifestTitle1 => GoogleFonts.roboto(
        color: const Color(0xffFFFFFF),
        fontSize: 18,
        fontWeight: FontWeight.w700,
      );

  TextStyle get credentialManifestDescription => GoogleFonts.roboto(
        color: const Color(0xffFFFFFF),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get credentialManifestTitle2 => GoogleFonts.roboto(
        color: const Color(0xffFFFFFF),
        fontSize: 16,
        fontWeight: FontWeight.w700,
      );

  TextStyle get credentialSubtitle => GoogleFonts.roboto(
        color: const Color(0xffFFFFFF),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  TextStyle get credentialStatus => GoogleFonts.roboto(
        color: const Color(0xffFFFFFF),
        fontSize: 18,
        fontWeight: FontWeight.w800,
      );

  TextStyle get beaconRequestPermission => GoogleFonts.roboto(
        color: const Color(0xff86809D),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get beaconSelectAccont => GoogleFonts.roboto(
        color: const Color(0xffFFFFFF),
        fontSize: 18,
        fontWeight: FontWeight.w800,
      );

  TextStyle get uploadFileTitle => GoogleFonts.roboto(
        color: const Color(0xffFFFFFF),
        fontSize: 18,
        fontWeight: FontWeight.w800,
      );

  TextStyle get beaconPermissionTitle => GoogleFonts.roboto(
        color: const Color(0xffFFFFFF),
        fontSize: 18,
        fontWeight: FontWeight.w800,
      );

  TextStyle get beaconPermissions => GoogleFonts.roboto(
        color: const Color(0xffFFFFFF),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get beaconPayload => GoogleFonts.roboto(
        color: const Color(0xffFFFFFF),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get beaconWalletAddress => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xffFFFFFF),
      );

  TextStyle get dappName => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xffFFFFFF),
      );

  TextStyle get cacheErrorMessage => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: const Color(0xffFFFFFF),
      );

  TextStyle get credentialSteps => GoogleFonts.roboto(
        color: const Color(0xffFFFFFF),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  TextStyle get discoverOverlayDescription => GoogleFonts.roboto(
        color: const Color(0xffFFFFFF),
        fontSize: 11,
        fontWeight: FontWeight.w600,
      );

  TextStyle get faqQue => GoogleFonts.roboto(
        color: const Color(0xffFFFFFF),
        fontSize: 16,
        fontWeight: FontWeight.normal,
      );

  TextStyle get faqAns => GoogleFonts.roboto(
        color: const Color(0xFF757575),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  TextStyle get proofCardDetail => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: const Color(0xffFFFFFF),
      );
}
