import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primary = Color(0xff6600FF);
const Color onPrimary = Color(0xff1A182D);
const Color secondary = Color(0xff00A1FF);
const Color onTertiary = Color(0xFF36334E);
const Color surface = Color(0xffFFFFFF);
const Color surfaceAccent = Color(0xffD1CCE3);
const Color onSurface = Color(0xff1D1D1D);
const Color shadow = Color(0xFFA79ABA);
const Color disabled = Color(0xFF605A71);
const Color error = Color(0xffcf6679);
const Color highlight = Color(0xFF180B2B);
const Color snackBarBackground = Colors.green;
const Color applied = Color(0xFF00B267);
const Color failed = Color(0xFFFF0045);
const Color skipped = Color(0xFFFF5F0A);
const Color activeNetwork = Color(0xFF2C7DF7);
const Color kyc = Color(0xFF0045FF);

abstract class AppTheme {
  /// A color frequently across your app’s screens and components.
  static Color darkPrimary = primary;

  /// A color that's clearly legible when drawn on primary
  static Color darkOnPrimary = onPrimary;

  /// An accent color used for less prominent components in the UI, such as
  /// filter chips, while expanding the opportunity for color expression.
  static Color darkSecondary = secondary;

  /// A color that's clearly legible when drawn on secondary
  static Color darkOnSecondary = onPrimary;

  /// A color used as a contrasting accent that can balance primary
  /// and secondary colors or bring heightened attention to an element,
  /// such as an input field.
  static Color darkTertiary = onPrimary;

  /// A color that's clearly legible when drawn on tertiary.
  static Color darkOnTertiary = onTertiary;

  /// The background color for widgets like Card.
  static Color darkSurface = surface;

  /// A color that's clearly legible when drawn on surface.
  static Color darkOnSurface = onSurface;

  /// A color that typically appears behind scrollable content.
  static Color darkBackground = surface;

  /// A color that's clearly legible when drawn on background.
  static Color darkOnBackground = onPrimary;

  /// The color to use for input validation errors, e.g. for
  /// InputDecoration.errorText
  static Color darkError = error;

  /// A color that's clearly legible when drawn on error.
  static Color darkOnError = surface;

  /// A color use to paint the drop shadows of elevated components.
  static Color darkShadow = shadow.withOpacity(0.1);

  static Color dividerColor = disabled;

  static Color highlightColor = highlight;

  static ThemeData get darkThemeData => ThemeData(
        brightness: Brightness.light,
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
          brightness: Brightness.light,
        ),
        textTheme: TextTheme(
          caption: GoogleFonts.nunito(
            color: onPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          headline6: GoogleFonts.nunito(
            color: onPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          headline5: GoogleFonts.nunito(
            color: onPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          headline4: GoogleFonts.nunito(
            color: onPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: primary),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: snackBarBackground,
          contentTextStyle: GoogleFonts.roboto(
            color: onPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
}

extension CustomColorScheme on ColorScheme {
  Color get transactionApplied => applied;
  Color get transactionFailed => failed;
  Color get transactionSkipped => skipped;
  Color get activeColorOfNetwork => activeNetwork;

  Color get greyText => onTertiary;

  Color get cardHighlighted => surface;

  Color get defaultDialogDark => surface;

  Color get closeIconColor => onSurface;

  Color get kycVerifyButton => kyc;

  Color get checkMarkColor => transactionApplied;

  Color get accountBottomSheetBorder => onPrimary;

  Color get digitPrimaryColor => onPrimary;

  Color get digitFillColor => Colors.transparent;

  Color get disabledBgColor => disabled;

  Color get disabledTextColor => disabled;

  Color get darkGradientStartColor => surface;

  Color get darkGradientEndColor => surface;

  Color get transparent => Colors.transparent;

  Color get onOutlineButton => primary;

  Color get onElevatedButton => onPrimary;

  Color get appBarUpperLayer => onSurface;

  Color get appBarLowerLayer => background;

  Color get surfaceContainer => surface.withOpacity(0.07);

  Color get drawerSurface => surface;

  Color get label => onPrimary;

  Color get unSelectedLabel => onSurface;

  Color get leadingButton => primary;

  Color get selectedBottomBar => surface;

  Color get drawerBackground => background;

  Color get borderColor => onSurface;

  Color get markDownH1 => onPrimary;

  Color get markDownH2 => onPrimary;

  Color get markDownP => onTertiary;

  Color get markDownA => secondary;

  Color get subtitle1 => onPrimary;

  Color get subtitle2 => secondary;

  Color get profileDummy => const Color(0xFF212121);

  Color get documentShadow => shadow;

  Color get documentShape => const Color(0xff3700b3).withOpacity(0.05);

  Color get star => const Color(0xFFFFB83D);

  Color get genderIcon => const Color(0xFF212121);

  Color get activeCredential => snackBarBackground;

  Color get expiredCredential => Colors.orange;

  Color get revokedCredential => Colors.red;

  Color get buttonDisabled => const Color(0xFF424242);

  Color get alertErrorMessage => Colors.red;

  Color get alertWarningMessage => Colors.yellow;

  Color get alertInfoMessage => Colors.cyan;

  Color get alertSuccessMessage => snackBarBackground;

  Color get qrScanBackground => surface;

  Color get qrScanInnerShadow => surface;

  Color get qrScanOuterShadow => primary;

  Color get dialogText => surfaceAccent;

  Color get tabBarNotSelected => surfaceAccent;

  Color get credentialBackground => surface;

  Color get cryptoAccountNotSelected => disabled.withOpacity(0.15);

  Color get startButtonColorA => primary;

  Color get startButtonColorB => primary;

  Color get associatedWalletBorder => disabled;

  Color get deleteColor => surfaceAccent;

  Color get titleColor => onTertiary;

  Color get valueColor => onPrimary;

  Color get lightGrey => disabled;

  Color get darkGrey => surfaceAccent;

  Color get activeColor => transactionApplied;

  Color get inactiveColor => transactionFailed;

  Color get beaconBorder => onSurface;

  Color get cardBackground => surface;
}

extension CustomTextTheme on TextTheme {
  TextStyle get hintTextFieldStyle => GoogleFonts.nunito(
        fontSize: 14,
        height: 1.5,
        letterSpacing: 1.02,
        fontWeight: FontWeight.normal,
        color: onTertiary,
      );

  TextStyle get keyboardDigitTextStyle =>
      GoogleFonts.roboto(fontSize: 30, color: onPrimary);

  TextStyle get calculatorKeyboardDigitTextStyle => GoogleFonts.roboto(
        fontSize: 30,
        color: onPrimary,
        fontWeight: FontWeight.bold,
      );

  TextStyle get keyboardDeleteButtonTextStyle =>
      GoogleFonts.roboto(fontSize: 16, color: onPrimary);

  TextStyle get loadingText => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  TextStyle get starterTitleStyle => GoogleFonts.nunito(
        color: onPrimary,
        fontSize: 34,
        fontWeight: FontWeight.w700,
      );

  TextStyle get subtitle3 => GoogleFonts.nunito(
        color: onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ).copyWith(height: 1.4);

  TextStyle get customListTileTitleStyle => GoogleFonts.nunito(
        color: onPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      );

  TextStyle get customListTileSubTitleStyle => GoogleFonts.nunito(
        color: onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get starterSubTitleStyle => GoogleFonts.nunito(
        color: onPrimary,
        fontSize: 26,
        fontWeight: FontWeight.w600,
      );

  TextStyle get onBoardingTitleStyle => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      );

  TextStyle get onBoardingSubTitleStyle => GoogleFonts.roboto(
        color: onTertiary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get learnMoreTextStyle => GoogleFonts.roboto(
        color: onTertiary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        decoration: TextDecoration.underline,
      );

  TextStyle get infoTitle => GoogleFonts.roboto(
        color: onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  TextStyle get infoSubtitle => GoogleFonts.roboto(
        color: onTertiary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get normal => GoogleFonts.roboto(
        color: onTertiary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get appBar => GoogleFonts.nunito(
        color: onPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w800,
      );

  TextStyle get bottomBar => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 10,
        fontWeight: FontWeight.w600,
      );

  TextStyle get title => GoogleFonts.nunito(
        color: onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      );

  TextStyle get listTitle => GoogleFonts.roboto(
        color: onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  TextStyle get listSubtitle => GoogleFonts.roboto(
        color: onSurface,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  TextStyle get caption2 => GoogleFonts.roboto(
        color: const Color(0xFF8682A8),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get caption3 => GoogleFonts.nunito(
        color: onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get listTileTitle => GoogleFonts.roboto(
        color: onPrimary,
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
        color: onSurface,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get drawerMenu => GoogleFonts.roboto(
        color: onTertiary,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      );

  TextStyle get drawerItem => GoogleFonts.nunito(
        color: onPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      );

  TextStyle get drawerCategoryTitle => GoogleFonts.nunito(
        color: onPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      );

  TextStyle get resetWalletTitle => GoogleFonts.nunito(
        color: onPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      );
  TextStyle get resetWalletSubtitle => GoogleFonts.nunito(
        color: onPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );
  TextStyle get subtitle4 => GoogleFonts.nunito(
        color: secondary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  TextStyle get drawerCategorySubTitle => GoogleFonts.nunito(
        color: onTertiary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get biometricMessage => GoogleFonts.roboto(
        color: onTertiary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get pinCodeTitle => GoogleFonts.nunito(
        color: onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      );

  TextStyle get pinCodeMessage => GoogleFonts.nunito(
        color: onPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  TextStyle get getCardsButton => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      );

  TextStyle get miniButton => GoogleFonts.nunito(
        color: onPrimary,
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
        color: onTertiary,
        fontSize: 14,
        fontWeight: FontWeight.w800,
      );

  TextStyle get discoverFieldDescription => GoogleFonts.roboto(
        color: onPrimary,
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
        color: onPrimary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      );

  TextStyle get professionalExperienceAssessmentRating => GoogleFonts.roboto(
        color: const Color(0xff212121),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  TextStyle get voucherOverlay => GoogleFonts.roboto(
        color: onPrimary,
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
        color: onPrimary,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      );

  TextStyle get tezosAssociatedAddressData => GoogleFonts.roboto(
        color: disabled,
        fontSize: 17,
        fontWeight: FontWeight.normal,
      );

  TextStyle get tezosAssociatedAddressTitleCard => GoogleFonts.nunito(
        color: const Color(0xffFAFDFF),
        fontSize: 20,
        fontWeight: FontWeight.w700,
      );

  TextStyle get credentialStudentCardTextCard => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

  TextStyle get over18 => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.normal,
      );

  TextStyle get studentCardSchool => GoogleFonts.roboto(
        color: const Color(0xff9dc5ff),
        fontSize: 15,
        fontWeight: FontWeight.bold,
      );

  TextStyle get studentCardData => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      );

  TextStyle get credentialTitleCard => GoogleFonts.roboto(
        color: onPrimary,
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
        color: onPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  TextStyle get dialogTitle => GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: onPrimary,
      );

  TextStyle get dialogSubtitle => GoogleFonts.roboto(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: onPrimary.withOpacity(0.67),
      );

  TextStyle get walletAltme => GoogleFonts.roboto(
        fontSize: 25,
        fontWeight: FontWeight.w600,
        color: const Color(0xff180B2B),
      );

  TextStyle get finishVerificationDialogTitle => GoogleFonts.nunito(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: const Color(0xff180B2B),
      );

  TextStyle get finishVerificationDialogBody => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF5F556F),
      );

  TextStyle get defaultDialogTitle => GoogleFonts.nunito(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: const Color(0xff180B2B),
      );

  TextStyle get defaultDialogBody => GoogleFonts.nunito(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF5F556F),
      );

  TextStyle get kycDialogTitle => GoogleFonts.nunito(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: const Color(0xff180B2B),
      );

  TextStyle get kycDialogCaption => GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: kyc,
      );

  TextStyle get kycDialogBody => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF180B2B),
      );

  TextStyle get kycDialogFooter => GoogleFonts.nunito(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF180B2B),
      );

  TextStyle get walletAltmeMessage => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xff9A8BB1),
      );

  TextStyle get credentialCategoryTitle => GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: onSurface,
      );

  TextStyle get credentialCategorySubTitle => GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: onSurface,
      );

  TextStyle get credentialSurfaceText => GoogleFonts.roboto(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: applied,
      );

  TextStyle get errorMessage => GoogleFonts.roboto(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: onPrimary,
      );

  TextStyle get accountsText => GoogleFonts.roboto(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: onPrimary,
      );

  TextStyle get accountsName => GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: onPrimary,
      );

  TextStyle get accountsListItemTitle => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: onPrimary,
      );

  TextStyle get walletAddress => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF757575),
      );

  TextStyle get textButton => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: primary,
      );

  TextStyle get scrollText => GoogleFonts.roboto(
        fontSize: 9,
        fontWeight: FontWeight.w500,
        color: onPrimary,
      );

  TextStyle get passPhraseText => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: onTertiary,
      );

  TextStyle get message => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: onSurface,
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

  TextStyle get identitiyBaseLightText => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: onPrimary,
      );
  TextStyle get identitiyBaseBoldText => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: onPrimary,
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
        color: onPrimary,
      );

  TextStyle get messageTitle => GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: onSurface,
      );

  TextStyle get messageSubtitle => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: onSurface,
      );

  TextStyle get radioTitle => GoogleFonts.nunito(
        color: onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  TextStyle get radioOption => GoogleFonts.nunito(
        color: onPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get credentialManifestTitle1 => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      );

  TextStyle get credentialManifestDescription => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get credentialManifestTitle2 => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      );

  TextStyle get credentialSubtitle => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  TextStyle get credentialStatus => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      );

  TextStyle get beaconRequestPermission => GoogleFonts.roboto(
        color: onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get beaconSelectAccont => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      );

  TextStyle get uploadFileTitle => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      );

  TextStyle get beaconPermissionTitle => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      );

  TextStyle get beaconPermissions => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get beaconPayload => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get beaconWalletAddress => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: onPrimary,
      );

  TextStyle get dappName => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: onPrimary,
      );

  TextStyle get cacheErrorMessage => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: onPrimary,
      );

  TextStyle get credentialSteps => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  TextStyle get discoverOverlayDescription => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      );
}
