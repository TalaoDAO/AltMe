import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);
  test('can access AppTheme', () {
    expect(AppTheme, isNotNull);
  });

  test('CustomColorScheme Test', () {
    const colorScheme = ColorScheme.dark();

    expect(colorScheme.error, const Color(0xFFFF0045));
    expect(colorScheme.onTertiary, const Color(0xFF00B267));
    expect(colorScheme.error, const Color(0xFFFF0045));
    expect(colorScheme.onErrorContainer, const Color(0xFFFF5F0A));
    expect(colorScheme.primary, const Color(0xFF2C7DF7));
    expect(colorScheme.onSurface.withOpacity(0.6), const Color(0xFFD1CCE3));
    expect(colorScheme.kycKeyIconColor, const Color(0xFF86809D));
    expect(colorScheme.lightPurple, const Color(0xFF5F556F));
    expect(colorScheme.popupBackground, const Color(0xff271C38));
    expect(colorScheme.cardHighlighted, const Color(0xFF251F38));
    expect(colorScheme.defaultDialogDark, const Color(0xFF322643));
    expect(colorScheme.closeIconColor, const Color(0xFFA79ABA));
    expect(colorScheme.kycVerifyButton, const Color(0xFF0045FF));
    expect(colorScheme.checkMarkColor, const Color(0xFF00B267));
    expect(colorScheme.accountBottomSheetBorder, equals(Colors.grey[200]));
    expect(colorScheme.digitPrimaryColor, equals(Colors.white));
    expect(colorScheme.digitFillColor, equals(Colors.transparent));
    expect(colorScheme.disabledBgColor, const Color(0xFF6A5F7B));
    expect(colorScheme.disabledTextColor, const Color(0xFF000000));
    expect(colorScheme.darkGradientStartColor, const Color(0xff0A0F19));
    expect(colorScheme.darkGradientEndColor, const Color(0xff25095B));
    expect(colorScheme.transparent, equals(Colors.transparent));
    expect(colorScheme.onOutlineButton, const Color(0xFF6600FF));
    expect(colorScheme.onElevatedButton, equals(Colors.white));
    expect(colorScheme.appBarUpperLayer, const Color(0xff25095B));
    expect(colorScheme.appBarLowerLayer, equals(colorScheme.surface));
    expect(
      colorScheme.surfaceContainer,
      equals(const Color(0xff707070).withOpacity(0.07)),
    );
    expect(colorScheme.drawerSurface, const Color(0xff232630));
    expect(colorScheme.label, equals(Colors.white));
    expect(colorScheme.unSelectedLabel, const Color(0xff86809D));
    expect(colorScheme.leadingButton, const Color(0xffF1EFF8));
    expect(colorScheme.selectedBottomBar, equals(colorScheme.surface));
    expect(colorScheme.drawerBackground, const Color(0xff0B0514));
    expect(colorScheme.borderColor, const Color(0xFFDDCEF4));
    expect(
      colorScheme.defualtDialogCancelButtonBorderColor,
      const Color(0xFFFFFFFF).withOpacity(0.2),
    );
    expect(colorScheme.markDownH1, equals(Colors.white));
    expect(colorScheme.markDownH2, equals(Colors.white));
    expect(colorScheme.markDownP, const Color(0xFFD1CCE3));
    expect(colorScheme.markDownA, const Color(0xff517bff));
    expect(colorScheme.subtitle1, equals(Colors.white));
    expect(colorScheme.subtitle2, const Color(0xFF8B8C92));
    expect(colorScheme.profileDummy, const Color(0xFF212121));
    expect(colorScheme.documentShadow, const Color(0xFF424242));
    expect(
      colorScheme.documentShape,
      equals(const Color(0xff3700b3).withOpacity(0.05)),
    );
    expect(colorScheme.star, const Color(0xFFFFB83D));
    expect(colorScheme.genderIcon, const Color(0xFF212121));
    expect(colorScheme.activeCredential, equals(Colors.green));
    expect(colorScheme.expiredCredential, equals(Colors.orange));
    expect(colorScheme.revokedCredential, equals(Colors.red));
    expect(colorScheme.buttonDisabled, const Color(0xFF424242));
    expect(colorScheme.alertErrorMessage, equals(Colors.red));
    expect(colorScheme.alertWarningMessage, equals(Colors.yellow));
    expect(colorScheme.alertInfoMessage, equals(Colors.cyan));
    expect(colorScheme.alertSuccessMessage, equals(Colors.green));
    expect(colorScheme.qrScanBackground, const Color(0xff2B1C48));
    expect(
      colorScheme.qrScanInnerShadow,
      const Color(0xff000000).withOpacity(0.16),
    );
    expect(colorScheme.qrScanOuterShadow, const Color(0xff430F91));
    expect(colorScheme.dialogText, const Color(0xffF5F5F5));
    expect(colorScheme.tabBarNotSelected, const Color(0xFF280164));
    expect(colorScheme.credentialBackground, const Color(0xFF211F33));
    expect(
      colorScheme.cryptoAccountNotSelected,
      equals(Colors.grey.withOpacity(0.15)),
    );
    expect(colorScheme.startButtonColorA, const Color(0xff18ACFF));
    expect(colorScheme.startButtonColorB, const Color(0xff6600FF));
    expect(colorScheme.associatedWalletBorder, const Color(0xff524B67));
    expect(colorScheme.deleteColor, const Color(0xff322643));
    expect(colorScheme.blueColor, const Color(0xff322643));
    expect(colorScheme.titleColor, const Color(0xffD1CCE3));
    expect(colorScheme.valueColor, const Color(0xffFFFFFF));
    expect(colorScheme.lightGrey, const Color(0xFF616161));
    expect(colorScheme.darkGrey, const Color(0xFF212121));
    expect(colorScheme.activeColor, const Color(0xFF08B530));
    expect(colorScheme.inactiveColor, const Color(0xFFFF0045));
    expect(colorScheme.beaconBorder, const Color(0xff86809D));
    expect(colorScheme.cardBackground, const Color(0xFF211F33));
  });

  test('CustomTextTheme extension test', () {
    const textTheme = TextTheme();

    expect(textTheme.hintTextFieldStyle.fontSize, 14);
    expect(textTheme.hintTextFieldStyle.fontSize, 14);
    expect(textTheme.hintTextFieldStyle.height, 1.5);
    expect(textTheme.hintTextFieldStyle.letterSpacing, 1.02);
    expect(textTheme.hintTextFieldStyle.fontWeight, FontWeight.normal);
    expect(textTheme.hintTextFieldStyle.color, const Color(0xffD1CCE3));

    expect(textTheme.textFieldTitle.color, const Color(0xFFFFFFFF));
    expect(textTheme.textFieldTitle.fontSize, 16);
    expect(textTheme.textFieldTitle.fontWeight, FontWeight.w400);

    expect(textTheme.keyboardDigitTextStyle.fontSize, 30);
    expect(textTheme.keyboardDigitTextStyle.color, Colors.white);

    expect(textTheme.calculatorKeyboardDigitTextStyle.fontSize, 30);
    expect(textTheme.calculatorKeyboardDigitTextStyle.color, Colors.white);
    expect(
      textTheme.calculatorKeyboardDigitTextStyle.fontWeight,
      FontWeight.bold,
    );

    expect(textTheme.keyboardDeleteButtonTextStyle.fontSize, 16);
    expect(textTheme.keyboardDeleteButtonTextStyle.color, Colors.white);

    expect(textTheme.loadingText.color, const Color(0xFFFFFFFF));
    expect(textTheme.loadingText.fontSize, 16);
    expect(textTheme.loadingText.fontWeight, FontWeight.w600);

    expect(textTheme.starterTitleStyle.color, const Color(0xFFFFFFFF));
    expect(textTheme.starterTitleStyle.fontSize, 32);
    expect(textTheme.starterTitleStyle.fontWeight, FontWeight.w700);

    expect(textTheme.subtitle3.color, const Color(0xFF86809D));
    expect(textTheme.subtitle3.fontSize, 16);
    expect(textTheme.subtitle3.fontWeight, FontWeight.w400);
    expect(textTheme.subtitle3.height, 1.4);

    expect(textTheme.customListTileTitleStyle.color, const Color(0xFFFFFFFF));
    expect(textTheme.customListTileTitleStyle.fontSize, 18);
    expect(textTheme.customListTileTitleStyle.fontWeight, FontWeight.w800);

    expect(
      textTheme.customListTileSubTitleStyle.color,
      const Color(0xFF86809D),
    );
    expect(textTheme.customListTileSubTitleStyle.fontSize, 16);
    expect(textTheme.customListTileSubTitleStyle.fontWeight, FontWeight.w400);

    expect(textTheme.starterSubTitleStyle.color, const Color(0xFFEEEEEE));
    expect(textTheme.starterSubTitleStyle.fontSize, 22);
    expect(textTheme.starterSubTitleStyle.fontWeight, FontWeight.w600);

    expect(textTheme.badgeStyle.color, const Color(0xFFEEEEEE));
    expect(textTheme.badgeStyle.fontSize, 8);
    expect(textTheme.badgeStyle.fontWeight, FontWeight.w500);

    expect(textTheme.onBoardingTitleStyle.color, const Color(0xFFFFFFFF));
    expect(textTheme.onBoardingTitleStyle.fontSize, 22);
    expect(textTheme.onBoardingTitleStyle.fontWeight, FontWeight.w600);

    expect(textTheme.onBoardingSubTitleStyle.color, const Color(0xFFD1CCE3));
    expect(textTheme.onBoardingSubTitleStyle.fontSize, 16);
    expect(textTheme.onBoardingSubTitleStyle.fontWeight, FontWeight.w400);

    expect(textTheme.learnMoreTextStyle.color, const Color(0xFFD1CCE3));
    expect(textTheme.learnMoreTextStyle.fontSize, 16);
    expect(textTheme.learnMoreTextStyle.fontWeight, FontWeight.w400);
    expect(textTheme.learnMoreTextStyle.decoration, TextDecoration.underline);

    expect(textTheme.infoTitle.color, const Color(0xFFEDEAF5));
    expect(textTheme.infoTitle.fontSize, 20);
    expect(textTheme.infoTitle.fontWeight, FontWeight.w600);

    expect(textTheme.infoSubtitle.color, const Color(0xFFD1CCE3));
    expect(textTheme.infoSubtitle.fontSize, 16);
    expect(textTheme.infoSubtitle.fontWeight, FontWeight.w400);

    expect(textTheme.normal.color, const Color(0xFFD1CCE3));
    expect(textTheme.normal.fontSize, 16);
    expect(textTheme.normal.fontWeight, FontWeight.w400);

    expect(textTheme.appBar.color, const Color(0xFFFFFFFF));
    expect(textTheme.appBar.fontSize, 24);
    expect(textTheme.appBar.fontWeight, FontWeight.w800);

    expect(textTheme.bottomBar.color, const Color(0xFFFFFFFF));
    expect(textTheme.bottomBar.fontSize, 10);
    expect(textTheme.bottomBar.fontWeight, FontWeight.w600);

    expect(textTheme.title.color, const Color(0xFFFFFFFF));
    expect(textTheme.title.fontSize, 18);
    expect(textTheme.title.fontWeight, FontWeight.w800);

    expect(textTheme.listTitle.color, const Color(0xFFEDEAF5));
    expect(textTheme.listTitle.fontSize, 20);
    expect(textTheme.listTitle.fontWeight, FontWeight.w600);

    expect(textTheme.listSubtitle.color, const Color(0xFFEDEAF5));
    expect(textTheme.listSubtitle.fontSize, 13);
    expect(textTheme.listSubtitle.fontWeight, FontWeight.w500);

    expect(textTheme.bodySmall2.color, const Color(0xFF8682A8));
    expect(textTheme.bodySmall2.fontSize, 12);
    expect(textTheme.bodySmall2.fontWeight, FontWeight.w400);

    expect(textTheme.bodySmall3.color, const Color(0xFF86809D));
    expect(textTheme.bodySmall3.fontSize, 16);
    expect(textTheme.bodySmall3.fontWeight, FontWeight.w400);

    expect(textTheme.listTileTitle.color, const Color(0xFFFFFFFF));
    expect(textTheme.listTileTitle.fontSize, 14);
    expect(textTheme.listTileTitle.fontWeight, FontWeight.w600);

    expect(textTheme.listTileSubtitle.color, const Color(0xFF8682A8));
    expect(textTheme.listTileSubtitle.fontSize, 12);
    expect(textTheme.listTileSubtitle.fontWeight, FontWeight.w400);

    expect(textTheme.close.color, const Color(0xFFD6C3F2));
    expect(textTheme.close.fontSize, 13);
    expect(textTheme.close.fontWeight, FontWeight.w400);

    expect(textTheme.dialogClose.color, const Color(0xFFA79ABA));
    expect(textTheme.dialogClose.fontSize, 12);
    expect(textTheme.dialogClose.fontWeight, FontWeight.w400);

    expect(textTheme.drawerMenu.color, const Color(0xFFD1CCE3));
    expect(textTheme.drawerMenu.fontSize, 15);
    expect(textTheme.drawerMenu.fontWeight, FontWeight.w400);

    expect(textTheme.drawerItemTitle.color, const Color(0xFFFFFFFF));
    expect(textTheme.drawerItemTitle.fontSize, 16);
    expect(textTheme.drawerItemTitle.fontWeight, FontWeight.w800);

    expect(textTheme.drawerItemSubtitle.color, const Color(0xFFD1CCE3));
    expect(textTheme.drawerItemSubtitle.fontSize, 14);
    expect(textTheme.drawerItemSubtitle.fontWeight, FontWeight.w500);

    expect(textTheme.drawerCategoryTitle.color, const Color(0xFFFFFFFF));
    expect(textTheme.drawerCategoryTitle.fontSize, 18);
    expect(textTheme.drawerCategoryTitle.fontWeight, FontWeight.w800);

    expect(textTheme.resetWalletTitle.color, const Color(0xFFFFFFFF));
    expect(textTheme.resetWalletTitle.fontSize, 16);
    expect(textTheme.resetWalletTitle.fontWeight, FontWeight.w700);

    expect(textTheme.resetWalletSubtitle.color, const Color(0xFFFFFFFF));
    expect(textTheme.resetWalletSubtitle.fontSize, 16);
    expect(textTheme.resetWalletSubtitle.fontWeight, FontWeight.w500);

    expect(textTheme.subtitle4.color, const Color(0xFF00A1FF));
    expect(textTheme.subtitle4.fontSize, 16);
    expect(textTheme.subtitle4.fontWeight, FontWeight.w500);

    expect(textTheme.drawerCategorySubTitle.color, const Color(0xFFD1CCE3));
    expect(textTheme.drawerCategorySubTitle.fontSize, 16);
    expect(textTheme.drawerCategorySubTitle.fontWeight, FontWeight.w400);

    expect(textTheme.biometricMessage.color, const Color(0xFFB1ADC3));
    expect(textTheme.biometricMessage.fontSize, 12);
    expect(textTheme.biometricMessage.fontWeight, FontWeight.w400);

    expect(textTheme.pinCodeTitle.color, const Color(0xFFFFFFFF));
    expect(textTheme.pinCodeTitle.fontSize, 20);
    expect(textTheme.pinCodeTitle.fontWeight, FontWeight.w700);

    expect(textTheme.pinCodeMessage.color, const Color(0xFFFFFFFF));
    expect(textTheme.pinCodeMessage.fontSize, 14);
    expect(textTheme.pinCodeMessage.fontWeight, FontWeight.w400);

    expect(textTheme.getCardsButton.color, const Color(0xFFFFFFFF));
    expect(textTheme.getCardsButton.fontSize, 12);
    expect(textTheme.getCardsButton.fontWeight, FontWeight.w600);

    expect(textTheme.miniButton.color, const Color(0xFFFFFFFF));
    expect(textTheme.miniButton.fontSize, 11);
    expect(textTheme.miniButton.fontWeight, FontWeight.w500);

    expect(textTheme.credentialTitle.color, const Color(0xFF424242));
    expect(textTheme.credentialTitle.fontSize, 15);
    expect(textTheme.credentialTitle.fontWeight, FontWeight.bold);

    expect(textTheme.credentialDescription.color, const Color(0xFF757575));
    expect(textTheme.credentialDescription.fontSize, 13);
    expect(textTheme.credentialDescription.fontWeight, FontWeight.w400);

    expect(textTheme.polygonCardDetail.color, const Color(0xffFFFFFF));
    expect(textTheme.polygonCardDetail.fontSize, 13);
    expect(textTheme.polygonCardDetail.fontWeight, FontWeight.w400);

    expect(textTheme.credentialFieldTitle.color, const Color(0xff212121));
    expect(textTheme.credentialFieldTitle.fontSize, 14);
    expect(textTheme.credentialFieldTitle.fontWeight, FontWeight.w400);

    expect(textTheme.credentialFieldDescription.color, const Color(0xff212121));
    expect(textTheme.credentialFieldDescription.fontSize, 14);
    expect(textTheme.credentialFieldDescription.fontWeight, FontWeight.w400);
    expect(textTheme.credentialFieldDescription.height, 1.5);

    expect(textTheme.discoverFieldTitle.color, const Color(0xffD1CCE3));
    expect(textTheme.discoverFieldTitle.fontSize, 14);
    expect(textTheme.discoverFieldTitle.fontWeight, FontWeight.w800);

    expect(textTheme.discoverFieldDescription.color, const Color(0xffFFFFFF));
    expect(textTheme.discoverFieldDescription.fontSize, 14);
    expect(textTheme.discoverFieldDescription.fontWeight, FontWeight.w400);
    expect(textTheme.discoverFieldDescription.height, 1.5);

    expect(textTheme.learningAchievementTitle.color, const Color(0xff212121));
    expect(textTheme.learningAchievementTitle.fontSize, 12);
    expect(textTheme.learningAchievementTitle.fontWeight, FontWeight.w600);

    expect(
      textTheme.learningAchievementDescription.color,
      const Color(0xff212121),
    );
    expect(textTheme.learningAchievementDescription.fontSize, 12);
    expect(
      textTheme.learningAchievementDescription.fontWeight,
      FontWeight.w400,
    );

    expect(textTheme.credentialIssuer.color, const Color(0xff212121));
    expect(textTheme.credentialIssuer.fontSize, 13);
    expect(textTheme.credentialIssuer.fontWeight, FontWeight.w500);

    expect(textTheme.imageCard.color, const Color(0xff212121));
    expect(textTheme.imageCard.fontSize, 12);
    expect(textTheme.imageCard.fontWeight, FontWeight.w500);

    expect(textTheme.loyaltyCard.color, const Color(0xffffffff));
    expect(textTheme.loyaltyCard.fontSize, 13);
    expect(textTheme.loyaltyCard.fontWeight, FontWeight.w600);

    expect(
      textTheme.professionalExperienceAssessmentRating.color,
      const Color(0xff212121),
    );
    expect(textTheme.professionalExperienceAssessmentRating.fontSize, 13);
    expect(
      textTheme.professionalExperienceAssessmentRating.fontWeight,
      FontWeight.w500,
    );

    expect(textTheme.voucherOverlay.color, const Color(0xffFFFFFF));
    expect(textTheme.voucherOverlay.fontSize, 13);
    expect(textTheme.voucherOverlay.fontWeight, FontWeight.w500);

    expect(
      textTheme.certificateOfEmploymentTitleCard.color,
      const Color(0xFF0650C6),
    );
    expect(textTheme.certificateOfEmploymentTitleCard.fontSize, 20);
    expect(
      textTheme.certificateOfEmploymentTitleCard.fontWeight,
      FontWeight.bold,
    );

    expect(
      textTheme.certificateOfEmploymentDescription.color,
      const Color(0xFF757575),
    );
    expect(textTheme.certificateOfEmploymentDescription.fontSize, 13);
    expect(
      textTheme.certificateOfEmploymentDescription.fontWeight,
      FontWeight.normal,
    );

    expect(
      textTheme.certificateOfEmploymentData.color,
      const Color(0xFF434e62),
    );
    expect(textTheme.certificateOfEmploymentData.fontSize, 12);
    expect(textTheme.certificateOfEmploymentData.fontWeight, FontWeight.normal);

    expect(textTheme.identityCardData.color, const Color(0xFFFFFFFF));
    expect(textTheme.identityCardData.fontSize, 12);
    expect(textTheme.identityCardData.fontWeight, FontWeight.normal);

    expect(textTheme.tezosAssociatedAddressData.color, const Color(0xff605A71));
    expect(textTheme.tezosAssociatedAddressData.fontSize, 17);
    expect(textTheme.tezosAssociatedAddressData.fontWeight, FontWeight.normal);

    expect(
      textTheme.tezosAssociatedAddressTitleCard.color,
      const Color(0xffFAFDFF),
    );
    expect(textTheme.tezosAssociatedAddressTitleCard.fontSize, 20);
    expect(
      textTheme.tezosAssociatedAddressTitleCard.fontWeight,
      FontWeight.w700,
    );

    expect(
      textTheme.credentialStudentCardTextCard.color,
      const Color(0xffffffff),
    );
    expect(textTheme.credentialStudentCardTextCard.fontSize, 14);
    expect(
      textTheme.credentialStudentCardTextCard.fontWeight,
      FontWeight.normal,
    );

    expect(textTheme.over18.color, const Color(0xffffffff));
    expect(textTheme.over18.fontSize, 20);
    expect(textTheme.over18.fontWeight, FontWeight.normal);

    expect(textTheme.studentCardSchool.color, const Color(0xff9dc5ff));
    expect(textTheme.studentCardSchool.fontSize, 15);
    expect(textTheme.studentCardSchool.fontWeight, FontWeight.bold);

    expect(textTheme.studentCardData.color, const Color(0xffffffff));
    expect(textTheme.studentCardData.fontSize, 12);
    expect(textTheme.studentCardData.fontWeight, FontWeight.normal);

    expect(textTheme.credentialTitleCard.color, const Color(0xFFFFFFFF));
    expect(textTheme.credentialTitleCard.fontSize, 20);
    expect(textTheme.credentialTitleCard.fontWeight, FontWeight.bold);

    expect(textTheme.voucherValueCard.color, const Color(0xFFFEEA00));
    expect(textTheme.voucherValueCard.fontSize, 50);
    expect(textTheme.voucherValueCard.fontWeight, FontWeight.bold);

    expect(textTheme.credentialTextCard.color, const Color(0xff212121));
    expect(textTheme.credentialTextCard.fontSize, 14);
    expect(textTheme.credentialTextCard.fontWeight, FontWeight.normal);

    expect(textTheme.illustrationPageDescription.color, Colors.white);
    expect(textTheme.illustrationPageDescription.fontSize, 16);
    expect(textTheme.illustrationPageDescription.fontWeight, FontWeight.w600);

    expect(textTheme.defaultDialogTitle.color, const Color(0xffF5F5F5));
    expect(textTheme.defaultDialogTitle.fontSize, 24);
    expect(textTheme.defaultDialogTitle.fontWeight, FontWeight.bold);

    expect(textTheme.defaultDialogBody.color, const Color(0xFF86809D));
    expect(textTheme.defaultDialogBody.fontSize, 14);
    expect(textTheme.defaultDialogBody.fontWeight, FontWeight.w400);

    expect(textTheme.defaultDialogSubtitle.color, const Color(0xff86809D));
    expect(textTheme.defaultDialogSubtitle.fontSize, 16);

    expect(textTheme.newVersionTitle.color, const Color(0xFFFFFFFF));
    expect(textTheme.newVersionTitle.fontSize, 18);
    expect(textTheme.newVersionTitle.fontWeight, FontWeight.w800);

    expect(textTheme.kycDialogTitle.color, const Color(0xffF5F5F5));
    expect(textTheme.kycDialogTitle.fontSize, 25);
    expect(textTheme.kycDialogTitle.fontWeight, FontWeight.bold);

    expect(textTheme.kycDialogBodySmall.color, const Color(0xFF0045FF));
    expect(textTheme.kycDialogBodySmall.fontSize, 20);
    expect(textTheme.kycDialogBodySmall.fontWeight, FontWeight.bold);

    expect(textTheme.kycDialogBody.color, const Color(0xff86809D));
    expect(textTheme.kycDialogBody.fontSize, 14);
    expect(textTheme.kycDialogBody.fontWeight, FontWeight.w700);

    expect(textTheme.kycDialogFooter.color, const Color(0xff86809D));
    expect(textTheme.kycDialogFooter.fontSize, 10);
    expect(textTheme.kycDialogFooter.fontWeight, FontWeight.w500);

    expect(textTheme.credentialCategoryTitle.color, const Color(0xffEDEAF5));
    expect(textTheme.credentialCategoryTitle.fontSize, 18);
    expect(textTheme.credentialCategoryTitle.fontWeight, FontWeight.w600);

    expect(textTheme.credentialCategorySubTitle.color, const Color(0xFF86809D));
    expect(textTheme.credentialCategorySubTitle.fontSize, 14);
    expect(textTheme.credentialCategorySubTitle.fontWeight, FontWeight.normal);

    expect(textTheme.credentialSurfaceText.color, const Color(0xff00B267));
    expect(textTheme.credentialSurfaceText.fontSize, 10);
    expect(textTheme.credentialSurfaceText.fontWeight, FontWeight.w400);

    expect(textTheme.errorMessage.color, const Color(0xffFFFFFF));
    expect(textTheme.errorMessage.fontSize, 15);
    expect(textTheme.errorMessage.fontWeight, FontWeight.w400);

    expect(textTheme.accountsText.color, const Color(0xffFFFFFF));
    expect(textTheme.accountsText.fontSize, 22);
    expect(textTheme.accountsText.fontWeight, FontWeight.w600);

    expect(textTheme.accountsName.color, const Color(0xffFFFFFF));
    expect(textTheme.accountsName.fontSize, 18);
    expect(textTheme.accountsName.fontWeight, FontWeight.w500);

    expect(textTheme.accountsListItemTitle.color, const Color(0xffFFFFFF));
    expect(textTheme.accountsListItemTitle.fontSize, 16);
    expect(textTheme.accountsListItemTitle.fontWeight, FontWeight.w500);

    expect(textTheme.walletAddress.color, const Color(0xFF757575));
    expect(textTheme.walletAddress.fontSize, 12);
    expect(textTheme.walletAddress.fontWeight, FontWeight.w400);

    expect(textTheme.textButton.color, const Color(0xff6600FF));
    expect(textTheme.textButton.fontSize, 16);
    expect(textTheme.textButton.fontWeight, FontWeight.w700);

    expect(textTheme.scrollText.color, const Color(0xffFFFFFF));
    expect(textTheme.scrollText.fontSize, 9);
    expect(textTheme.scrollText.fontWeight, FontWeight.w500);

    expect(textTheme.passPhraseText.color, const Color(0xffD1CCE3));
    expect(textTheme.passPhraseText.fontSize, 14);
    expect(textTheme.passPhraseText.fontWeight, FontWeight.w600);

    expect(textTheme.message.color, const Color(0xffEDEAF5));
    expect(textTheme.message.fontSize, 18);
    expect(textTheme.message.fontWeight, FontWeight.w600);

    expect(textTheme.subMessage.color, const Color(0xff71CBFF));
    expect(textTheme.subMessage.fontSize, 15);
    expect(textTheme.subMessage.fontWeight, FontWeight.w400);

    expect(textTheme.genPhraseSubmessage.color, const Color(0xff71CBFF));
    expect(textTheme.genPhraseSubmessage.fontSize, 18);
    expect(textTheme.genPhraseSubmessage.fontWeight, FontWeight.w400);

    expect(textTheme.pheaseVerifySubmessage.color, const Color(0xff86809D));
    expect(textTheme.pheaseVerifySubmessage.fontSize, 18);
    expect(textTheme.pheaseVerifySubmessage.fontWeight, FontWeight.w400);

    expect(textTheme.credentialBaseLightText.color, const Color(0xffFFFFFF));
    expect(textTheme.credentialBaseLightText.fontSize, 16);
    expect(textTheme.credentialBaseLightText.fontWeight, FontWeight.w300);

    expect(textTheme.credentialBaseBoldText.color, const Color(0xffFFFFFF));
    expect(textTheme.credentialBaseBoldText.fontSize, 16);
    expect(textTheme.credentialBaseBoldText.fontWeight, FontWeight.w600);

    expect(textTheme.credentialBaseTitleText.color, const Color(0xffFFFFFF));
    expect(textTheme.credentialBaseTitleText.fontSize, 36);
    expect(textTheme.credentialBaseTitleText.fontWeight, FontWeight.w600);

    expect(textTheme.copyToClipBoard.color, const Color(0xffDED6EA));
    expect(textTheme.copyToClipBoard.fontSize, 18);
    expect(textTheme.copyToClipBoard.fontWeight, FontWeight.w400);
    expect(textTheme.copyToClipBoard.decoration, TextDecoration.underline);

    expect(textTheme.onBoardingCheckMessage.color, const Color(0xFFFFFFFF));
    expect(textTheme.onBoardingCheckMessage.fontSize, 18);
    expect(textTheme.onBoardingCheckMessage.fontWeight, FontWeight.w700);

    expect(textTheme.messageTitle.color, const Color(0xffEDEAF5));
    expect(textTheme.messageTitle.fontSize, 20);
    expect(textTheme.messageTitle.fontWeight, FontWeight.w600);

    expect(textTheme.messageSubtitle.color, const Color(0xffEDEAF5));
    expect(textTheme.messageSubtitle.fontSize, 16);
    expect(textTheme.messageSubtitle.fontWeight, FontWeight.w400);

    expect(textTheme.radioTitle.color, const Color(0xFFFFFFFF));
    expect(textTheme.radioTitle.fontSize, 20);
    expect(textTheme.radioTitle.fontWeight, FontWeight.w600);

    expect(textTheme.radioOption.color, const Color(0xFFFFFFFF));
    expect(textTheme.radioOption.fontSize, 16);
    expect(textTheme.radioOption.fontWeight, FontWeight.w400);

    expect(textTheme.credentialManifestTitle1.color, const Color(0xffFFFFFF));
    expect(textTheme.credentialManifestTitle1.fontSize, 18);
    expect(textTheme.credentialManifestTitle1.fontWeight, FontWeight.w700);

    expect(
      textTheme.credentialManifestDescription.color,
      const Color(0xffFFFFFF),
    );
    expect(textTheme.credentialManifestDescription.fontSize, 16);
    expect(textTheme.credentialManifestDescription.fontWeight, FontWeight.w400);

    expect(textTheme.credentialManifestTitle2.color, const Color(0xffFFFFFF));
    expect(textTheme.credentialManifestTitle2.fontSize, 16);
    expect(textTheme.credentialManifestTitle2.fontWeight, FontWeight.w700);

    expect(textTheme.credentialSubtitle.color, const Color(0xffFFFFFF));
    expect(textTheme.credentialSubtitle.fontSize, 14);
    expect(textTheme.credentialSubtitle.fontWeight, FontWeight.w400);

    expect(textTheme.credentialStatus.color, const Color(0xffFFFFFF));
    expect(textTheme.credentialStatus.fontSize, 18);
    expect(textTheme.credentialStatus.fontWeight, FontWeight.w800);

    expect(textTheme.beaconRequestPermission.color, const Color(0xff86809D));
    expect(textTheme.beaconRequestPermission.fontSize, 16);
    expect(textTheme.beaconRequestPermission.fontWeight, FontWeight.w400);

    expect(textTheme.beaconSelectAccont.color, const Color(0xffFFFFFF));
    expect(textTheme.beaconSelectAccont.fontSize, 18);
    expect(textTheme.beaconSelectAccont.fontWeight, FontWeight.w800);

    expect(textTheme.uploadFileTitle.color, const Color(0xffFFFFFF));
    expect(textTheme.uploadFileTitle.fontSize, 18);
    expect(textTheme.uploadFileTitle.fontWeight, FontWeight.w800);

    expect(textTheme.beaconPermissionTitle.color, const Color(0xffFFFFFF));
    expect(textTheme.beaconPermissionTitle.fontSize, 18);
    expect(textTheme.beaconPermissionTitle.fontWeight, FontWeight.w800);

    expect(textTheme.beaconPermissions.color, const Color(0xffFFFFFF));
    expect(textTheme.beaconPermissions.fontSize, 16);
    expect(textTheme.beaconPermissions.fontWeight, FontWeight.w400);

    expect(textTheme.beaconPayload.color, const Color(0xffFFFFFF));
    expect(textTheme.beaconPayload.fontSize, 16);
    expect(textTheme.beaconPayload.fontWeight, FontWeight.w400);

    expect(textTheme.beaconWalletAddress.color, const Color(0xffFFFFFF));
    expect(textTheme.beaconWalletAddress.fontSize, 16);
    expect(textTheme.beaconWalletAddress.fontWeight, FontWeight.w400);

    expect(textTheme.dappName.color, const Color(0xffFFFFFF));
    expect(textTheme.dappName.fontSize, 16);
    expect(textTheme.dappName.fontWeight, FontWeight.w400);

    expect(textTheme.cacheErrorMessage.color, const Color(0xffFFFFFF));
    expect(textTheme.cacheErrorMessage.fontSize, 16);
    expect(textTheme.cacheErrorMessage.fontWeight, FontWeight.w600);

    expect(textTheme.credentialSteps.color, const Color(0xffFFFFFF));
    expect(textTheme.credentialSteps.fontSize, 18);
    expect(textTheme.credentialSteps.fontWeight, FontWeight.w600);

    expect(textTheme.faqQue.color, const Color(0xffFFFFFF));
    expect(textTheme.faqQue.fontSize, 16);
    expect(textTheme.faqQue.fontWeight, FontWeight.normal);

    expect(textTheme.faqAns.color, const Color(0xFF757575));
    expect(textTheme.faqAns.fontSize, 14);
    expect(textTheme.faqAns.fontWeight, FontWeight.w400);

    expect(textTheme.proofCardDetail.color, const Color(0xffFFFFFF));
    expect(textTheme.proofCardDetail.fontSize, 12);
    expect(textTheme.proofCardDetail.fontWeight, FontWeight.w300);
  });
}
