import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primary = icon;
//
const Color onPrimary = Color(0xffFFFFFF);
const Color secondary = Color(0xff00A1FF);
const Color onTertiary = Color(0xFFECF3FA);
// secondary dans figma Christophe pour new talao
const Color surface = Color(0xff191D2E);
const Color onSurface = Color(0xffEDEAF5);
const Color background = Color(0xff020820);
const Color error = Color(0xffcf6679);
const Color onError = Colors.black;
Color shadow = const Color(0xff1D1D1D).withOpacity(0.1);
const Color divider = Color(0xFF605A71);
const Color highlight = Color(0xFF36334E);
const Color icon = Color(0xff1EAADC);
const Color snackBarBackground = Colors.green;
const Color applied = Color(0xFF00B267);
const Color failed = Color(0xFFFF0045);
const Color skipped = Color(0xFFFF5F0A);
const Color network = Color(0xFF2C7DF7);

const Color cardHighlight = Color(0xFF251F38);
const Color defaultDialog = Color(0xFF322643);
const Color closeIcon = Color(0xFFA79ABA);
const Color kycVerifyButton = Color(0xFF0045FF);
Color accountBottomSheetBorder = Colors.grey[200]!;
const Color digitPrimary = Colors.white;
const Color pinCodeMiniCircle = Color(0xFF656A73);
const Color startButtonA = Color(0xFF1EA3DC);
const Color startButtonB = Color(0xFF1EAADC);

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
  static Color darkBackground = background;

  /// A color that's clearly legible when drawn on background.
  static Color darkOnBackground = onPrimary;

  /// The color to use for input validation errors, e.g. for
  /// InputDecoration.errorText
  static const Color darkError = error;

  /// A color that's clearly legible when drawn on error.
  static const Color darkOnError = onError;

  /// A color use to paint the drop shadows of elevated components.
  static Color darkShadow = shadow;

  static Color dividerColor = divider;

  static Color highlightColor = highlight;

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
          caption: GoogleFonts.poppins(
            color: onPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          headline6: GoogleFonts.poppins(
            color: onPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          headline5: GoogleFonts.poppins(
            color: onPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          headline4: GoogleFonts.poppins(
            color: onPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: icon),
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
  Color get activeColorOfNetwork => network;

  Color get greyText => onTertiary;

  Color get cardHighlighted => cardHighlight;

  Color get defaultDialogDark => defaultDialog;

  Color get closeIconColor => closeIcon;

  Color get kycVerifyButtonColor => kycVerifyButton;

  Color get checkMarkColor => applied;

  Color get accountBottomSheetBorderColor => accountBottomSheetBorder;

  Color get digitPrimaryColor => digitPrimary;

  Color get digitFillColor => Colors.transparent;

  Color get disabledBgColor => const Color(0xFF6A5F7B);

  Color get disabledTextColor => const Color(0xFF000000);

  Color get darkGradientStartColor => background;

  Color get darkGradientEndColor => background;

  Color get transparent => Colors.transparent;

  Color get onOutlineButton => primary;

  Color get onElevatedButton => onPrimary;

  Color get appBarUpperLayer => const Color(0xff25095B);

  Color get appBarLowerLayer => background;

  Color get surfaceContainer => const Color(0xff707070).withOpacity(0.07);

  // Color get drawerSurface => const Color(0xff232630);
  Color get drawerSurface => surface;

  Color get label => digitPrimary;

  Color get unSelectedLabel => onTertiary;

  Color get leadingButton => const Color(0xffF1EFF8);

  Color get selectedBottomBar => surface;

  Color get drawerBackground => background;

  Color get borderColor => const Color(0xFFDDCEF4);

  Color get markDownH1 => onPrimary;

  Color get markDownH2 => onPrimary;

  Color get markDownP => onTertiary;

  Color get markDownA => const Color(0xff517bff);

  Color get subtitle1 => onPrimary;

  Color get subtitle2 => const Color(0xFF8B8C92);

  Color get profileDummy => const Color(0xFF212121);

  Color get documentShadow => const Color(0xFF424242);

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

  Color get qrScanBackground => const Color(0xff191D2E);

  Color get qrScanInnerShadow => const Color(0xff0A0215);

  Color get dialogText => const Color(0xFF180B2B);

  Color get tabBarNotSelected => const Color(0xFF280164);

  Color get credentialBackground => const Color(0xFF211F33);

  Color get cryptoAccountNotSelected => Colors.grey.withOpacity(0.15);

  Color get startButtonColorA => startButtonA;

  Color get startButtonColorB => startButtonB;

  Color get associatedWalletBorder => const Color(0xff524B67);

  Color get deleteColor => defaultDialog;

  Color get titleColor => onTertiary;

  Color get valueColor => onPrimary;

  Color get lightGrey => const Color(0xFF616161);

  Color get darkGrey => const Color(0xFF212121);

  Color get activeColor => const Color(0xFF08B530);

  Color get inactiveColor => failed;

  Color get beaconBorder => onTertiary;

  Color get cardBackground => const Color(0xFF211F33);
}

extension CustomTextTheme on TextTheme {
  TextStyle get hintTextFieldStyle => GoogleFonts.poppins(
        fontSize: 14,
        height: 1.5,
        letterSpacing: 1.02,
        fontWeight: FontWeight.normal,
        color: onTertiary,
      );

  TextStyle get keyboardDigitTextStyle =>
      GoogleFonts.roboto(fontSize: 30, color: digitPrimary);

  TextStyle get calculatorKeyboardDigitTextStyle => GoogleFonts.roboto(
        fontSize: 30,
        color: digitPrimary,
        fontWeight: FontWeight.bold,
      );

  TextStyle get keyboardDeleteButtonTextStyle =>
      GoogleFonts.roboto(fontSize: 16, color: digitPrimary);

  TextStyle get loadingText => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  TextStyle get starterTitleStyle => GoogleFonts.poppins(
        color: onPrimary,
        fontSize: 34,
        fontWeight: FontWeight.w700,
      );

  TextStyle get subtitle3 => GoogleFonts.poppins(
        color: onTertiary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ).copyWith(height: 1.4);

  TextStyle get customListTileTitleStyle => GoogleFonts.poppins(
        color: onPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      );

  TextStyle get customListTileSubTitleStyle => GoogleFonts.poppins(
        color: onTertiary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get starterSubTitleStyle => GoogleFonts.poppins(
        color: const Color(0xFFEEEEEE),
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

  TextStyle get appBar => GoogleFonts.poppins(
        color: onPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w800,
      );

  TextStyle get bottomBar => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 10,
        fontWeight: FontWeight.w600,
      );

  TextStyle get title => GoogleFonts.poppins(
        color: onPrimary,
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

  TextStyle get caption3 => GoogleFonts.poppins(
        color: onTertiary,
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
        color: closeIcon,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get drawerMenu => GoogleFonts.roboto(
        color: onTertiary,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      );

  TextStyle get drawerItem => GoogleFonts.poppins(
        color: onPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      );

  TextStyle get drawerCategoryTitle => GoogleFonts.poppins(
        color: onPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      );

  TextStyle get resetWalletTitle => GoogleFonts.poppins(
        color: onPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      );
  TextStyle get resetWalletSubtitle => GoogleFonts.poppins(
        color: onPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );
  TextStyle get subtitle4 => GoogleFonts.poppins(
        color: secondary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  TextStyle get drawerCategorySubTitle => GoogleFonts.poppins(
        color: onTertiary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get biometricMessage => GoogleFonts.roboto(
        color: const Color(0xFFB1ADC3),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle get pinCodeTitle => GoogleFonts.poppins(
        color: onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      );

  TextStyle get pinCodeMessage => GoogleFonts.poppins(
        color: onPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  TextStyle get getCardsButton => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      );

  TextStyle get miniButton => GoogleFonts.poppins(
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
        color: divider,
        fontSize: 17,
        fontWeight: FontWeight.normal,
      );

  TextStyle get tezosAssociatedAddressTitleCard => GoogleFonts.poppins(
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
        color: digitPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  TextStyle get dialogTitle => GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: digitPrimary,
      );

  TextStyle get dialogSubtitle => GoogleFonts.roboto(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: digitPrimary.withOpacity(0.67),
      );

  TextStyle get walletAltme => GoogleFonts.roboto(
        fontSize: 25,
        fontWeight: FontWeight.w600,
        color: const Color(0xff180B2B),
      );

  TextStyle get finishVerificationDialogTitle => GoogleFonts.poppins(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: const Color(0xff180B2B),
      );

  TextStyle get finishVerificationDialogBody => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF5F556F),
      );

  TextStyle get defaultDialogTitle => GoogleFonts.poppins(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: const Color(0xff180B2B),
      );

  TextStyle get defaultDialogBody => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF5F556F),
      );

  TextStyle get kycDialogTitle => GoogleFonts.poppins(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: const Color(0xff180B2B),
      );

  TextStyle get kycDialogCaption => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: kycVerifyButton,
      );

  TextStyle get kycDialogBody => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF180B2B),
      );

  TextStyle get kycDialogFooter => GoogleFonts.poppins(
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
        color: onTertiary,
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

  TextStyle get accountsListItemTitle => GoogleFonts.poppins(
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

  TextStyle get passPhraseText => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: onTertiary,
      );

  TextStyle get message => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: onSurface,
      );

  TextStyle get subMessage => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: const Color(0xff71CBFF),
      );

  TextStyle get genPhraseSubmessage => GoogleFonts.poppins(
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

  TextStyle get copyToClipBoard => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: const Color(0xffDED6EA),
        decoration: TextDecoration.underline,
      );

  TextStyle get onBoardingCheckMessage => GoogleFonts.poppins(
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

  TextStyle get radioTitle => GoogleFonts.poppins(
        color: onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  TextStyle get radioOption => GoogleFonts.poppins(
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
        color: onTertiary,
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

  TextStyle get faqQue => GoogleFonts.roboto(
        color: onPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w700,
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
