import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/helpers.dart';

void main() {
  test('can access AppTheme', () {
    expect(AppTheme, isNotNull);
  });

  group('Dark CustomColorScheme', () {
    testWidgets('dark color is rendered correctly', (tester) async {
      await tester.pumpApp(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.dark),
          home: Builder(
            builder: (context) => Column(
              children: [
                Container(
                  key: const Key('transparent'),
                  color: Theme.of(context).colorScheme.transparent,
                ),
                Container(
                  key: const Key('leadingButton'),
                  color: Theme.of(context).colorScheme.leadingButton,
                ),
                Container(
                  key: const Key('selectedBottomBar'),
                  color: Theme.of(context).colorScheme.selectedBottomBar,
                ),
                Container(
                  key: const Key('borderColor'),
                  color: Theme.of(context).colorScheme.borderColor,
                ),
                Container(
                  key: const Key('markDownH1'),
                  color: Theme.of(context).colorScheme.markDownH1,
                ),
                Container(
                  key: const Key('markDownH2'),
                  color: Theme.of(context).colorScheme.markDownH2,
                ),
                Container(
                  key: const Key('markDownP'),
                  color: Theme.of(context).colorScheme.markDownP,
                ),
                Container(
                  key: const Key('markDownA'),
                  color: Theme.of(context).colorScheme.markDownA,
                ),
                Container(
                  key: const Key('subtitle1'),
                  color: Theme.of(context).colorScheme.subtitle1,
                ),
                Container(
                  key: const Key('subtitle2'),
                  color: Theme.of(context).colorScheme.subtitle2,
                ),
                Container(
                  key: const Key('profileDummy'),
                  color: Theme.of(context).colorScheme.profileDummy,
                ),
                Container(
                  key: const Key('documentShadow'),
                  color: Theme.of(context).colorScheme.documentShadow,
                ),
                Container(
                  key: const Key('documentShape'),
                  color: Theme.of(context).colorScheme.documentShape,
                ),
                Container(
                  key: const Key('star'),
                  color: Theme.of(context).colorScheme.star,
                ),
                Container(
                  key: const Key('genderIcon'),
                  color: Theme.of(context).colorScheme.genderIcon,
                ),
                Container(
                  key: const Key('activeCredential'),
                  color: Theme.of(context).colorScheme.activeCredential,
                ),
                Container(
                  key: const Key('expiredCredential'),
                  color: Theme.of(context).colorScheme.expiredCredential,
                ),
                Container(
                  key: const Key('revokedCredential'),
                  color: Theme.of(context).colorScheme.revokedCredential,
                ),
                Container(
                  key: const Key('alertErrorMessage'),
                  color: Theme.of(context).colorScheme.alertErrorMessage,
                ),
                Container(
                  key: const Key('alertWarningMessage'),
                  color: Theme.of(context).colorScheme.alertWarningMessage,
                ),
                Container(
                  key: const Key('alertInfoMessage'),
                  color: Theme.of(context).colorScheme.alertInfoMessage,
                ),
                Container(
                  key: const Key('alertSuccessMessage'),
                  color: Theme.of(context).colorScheme.alertSuccessMessage,
                ),
                Container(
                  key: const Key('buttonDisabled'),
                  color: Theme.of(context).colorScheme.buttonDisabled,
                ),
              ],
            ),
          ),
        ),
      );
      final transparent =
          tester.widget<Container>(find.byKey(const Key('transparent')));
      expect(transparent.color, Colors.transparent);

      final appBar = tester.widget<Container>(find.byKey(const Key('appBar')));
      expect(appBar.color, const Color(0xFF1D1D1D));

      final backButton =
          tester.widget<Container>(find.byKey(const Key('backButton')));
      expect(backButton.color, const Color(0xFFADACAC));

      final selectedBottomBar =
          tester.widget<Container>(find.byKey(const Key('selectedBottomBar')));
      expect(selectedBottomBar.color, AppTheme.darkOnSurface);

      final borderColor =
          tester.widget<Container>(find.byKey(const Key('borderColor')));
      expect(borderColor.color, const Color(0xFF3B3A3A));

      final markDownH1 =
          tester.widget<Container>(find.byKey(const Key('markDownH1')));
      expect(markDownH1.color, const Color(0xFFDBD8D8));

      final markDownH2 =
          tester.widget<Container>(find.byKey(const Key('markDownH2')));
      expect(markDownH2.color, const Color(0xFFDBD8D8));

      final markDownP =
          tester.widget<Container>(find.byKey(const Key('markDownP')));
      expect(markDownP.color, const Color(0xFFADACAC));

      final markDownA =
          tester.widget<Container>(find.byKey(const Key('markDownA')));
      expect(markDownA.color, const Color(0xff517bff));

      final subtitle1 =
          tester.widget<Container>(find.byKey(const Key('subtitle1')));
      expect(subtitle1.color, const Color(0xFFFFFFFF));

      final subtitle2 =
          tester.widget<Container>(find.byKey(const Key('subtitle2')));
      expect(subtitle2.color, const Color(0xFF8B8C92));

      final button = tester.widget<Container>(find.byKey(const Key('button')));
      expect(button.color, const Color(0xFFEEEAEA));

      final profileDummy =
          tester.widget<Container>(find.byKey(const Key('profileDummy')));
      expect(profileDummy.color, const Color(0xFF212121));

      final documentShadow =
          tester.widget<Container>(find.byKey(const Key('documentShadow')));
      expect(documentShadow.color, const Color(0xFF424242));

      final documentShape =
          tester.widget<Container>(find.byKey(const Key('documentShape')));
      expect(
        documentShape.color,
        const Color(0xff3700b3).withOpacity(0.5),
      );

      final star = tester.widget<Container>(find.byKey(const Key('star')));
      expect(star.color, const Color(0xFFFFB83D));

      final genderIcon =
          tester.widget<Container>(find.byKey(const Key('genderIcon')));
      expect(genderIcon.color, const Color(0xFF212121));

      final activeCredential =
          tester.widget<Container>(find.byKey(const Key('activeCredential')));
      expect(activeCredential.color, Colors.green);

      final expiredCredential =
          tester.widget<Container>(find.byKey(const Key('expiredCredential')));
      expect(expiredCredential.color, Colors.orange);

      final revokedCredential =
          tester.widget<Container>(find.byKey(const Key('revokedCredential')));
      expect(revokedCredential.color, Colors.red);

      final alertErrorMessage =
          tester.widget<Container>(find.byKey(const Key('alertErrorMessage')));
      expect(alertErrorMessage.color, Colors.red);

      final alertWarningMessage = tester
          .widget<Container>(find.byKey(const Key('alertWarningMessage')));
      expect(alertWarningMessage.color, Colors.yellow);

      final alertInfoMessage =
          tester.widget<Container>(find.byKey(const Key('alertInfoMessage')));
      expect(alertInfoMessage.color, Colors.cyan);

      final alertSuccessMessage = tester
          .widget<Container>(find.byKey(const Key('alertSuccessMessage')));
      expect(alertSuccessMessage.color, Colors.green);

      final buttonDisabled =
          tester.widget<Container>(find.byKey(const Key('buttonDisabled')));
      expect(buttonDisabled.color, const Color(0xFF424242));
    });
  });

  group('CustomTextTheme', () {
    testWidgets('custom text theme rendered correctly', (tester) async {
      await tester.pumpApp(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.dark),
          home: Builder(
            builder: (context) => Column(
              children: [
                Text(
                  'credentialTitle',
                  key: const Key('credentialTitle'),
                  style: Theme.of(context).textTheme.credentialTitle,
                ),
                Text(
                  'credentialDescription',
                  key: const Key('credentialDescription'),
                  style: Theme.of(context).textTheme.credentialDescription,
                ),
                Text(
                  'credentialFieldTitle',
                  key: const Key('credentialFieldTitle'),
                  style: Theme.of(context).textTheme.credentialFieldTitle,
                ),
                Text(
                  'credentialFieldDescription',
                  key: const Key('credentialFieldDescription'),
                  style: Theme.of(context).textTheme.credentialFieldDescription,
                ),
                Text(
                  'learningAchievementTitle',
                  key: const Key('learningAchievementTitle'),
                  style: Theme.of(context).textTheme.learningAchievementTitle,
                ),
                Text(
                  'learningAchievementDescription',
                  key: const Key('learningAchievementDescription'),
                  style: Theme.of(context)
                      .textTheme
                      .learningAchievementDescription,
                ),
                Text(
                  'credentialIssuer',
                  key: const Key('credentialIssuer'),
                  style: Theme.of(context).textTheme.credentialIssuer,
                ),
                Text(
                  'imageCard',
                  key: const Key('imageCard'),
                  style: Theme.of(context).textTheme.imageCard,
                ),
                Text(
                  'loyaltyCard',
                  key: const Key('loyaltyCard'),
                  style: Theme.of(context).textTheme.loyaltyCard,
                ),
                Text(
                  'professionalExperienceAssessmentRating',
                  key: const Key('professionalExperienceAssessmentRating'),
                  style: Theme.of(context)
                      .textTheme
                      .professionalExperienceAssessmentRating,
                ),
                Text(
                  'voucherOverlay',
                  key: const Key('voucherOverlay'),
                  style: Theme.of(context).textTheme.voucherOverlay,
                ),
                Text(
                  'ecole42LearningAchievementStudentIdentity',
                  key: const Key('ecole42LearningAchievementStudentIdentity'),
                  style: Theme.of(context)
                      .textTheme
                      .ecole42LearningAchievementStudentIdentity,
                ),
                Text(
                  'ecole42LearningAchievementLevel',
                  key: const Key('ecole42LearningAchievementLevel'),
                  style: Theme.of(context)
                      .textTheme
                      .ecole42LearningAchievementLevel,
                ),
              ],
            ),
          ),
        ),
      );

      final brand = tester.widget<Text>(find.byKey(const Key('brand')));
      expect(
        brand.style,
        GoogleFonts.roboto(
          color: const Color(0xFFFFFFFF),
          fontSize: 28,
          fontWeight: FontWeight.w400,
        ),
      );

      final credentialTitle =
          tester.widget<Text>(find.byKey(const Key('credentialTitle')));
      expect(
        credentialTitle.style,
        GoogleFonts.roboto(
          color: const Color(0xFF424242),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );

      final credentialDescription =
          tester.widget<Text>(find.byKey(const Key('credentialDescription')));
      expect(
        credentialDescription.style,
        GoogleFonts.roboto(
          color: const Color(0xFF757575),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );

      final credentialFieldTitle =
          tester.widget<Text>(find.byKey(const Key('credentialFieldTitle')));
      expect(
        credentialFieldTitle.style,
        GoogleFonts.roboto(
          color: const Color(0xff212121),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      );

      final credentialFieldDescription = tester
          .widget<Text>(find.byKey(const Key('credentialFieldDescription')));
      expect(
        credentialFieldDescription.style,
        GoogleFonts.roboto(
          color: const Color(0xff212121),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      );

      final learningAchievementTitle = tester
          .widget<Text>(find.byKey(const Key('learningAchievementTitle')));
      expect(
        learningAchievementTitle.style,
        GoogleFonts.roboto(
          color: const Color(0xff212121),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      );

      final learningAchievementDescription = tester.widget<Text>(
        find.byKey(const Key('learningAchievementDescription')),
      );
      expect(
        learningAchievementDescription.style,
        GoogleFonts.roboto(
          color: const Color(0xff212121),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      );

      final credentialIssuer =
          tester.widget<Text>(find.byKey(const Key('credentialIssuer')));
      expect(
        credentialIssuer.style,
        GoogleFonts.roboto(
          color: const Color(0xff212121),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      );

      final imageCard = tester.widget<Text>(find.byKey(const Key('imageCard')));
      expect(
        imageCard.style,
        GoogleFonts.roboto(
          color: const Color(0xff212121),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      );

      final loyaltyCard =
          tester.widget<Text>(find.byKey(const Key('loyaltyCard')));
      expect(
        loyaltyCard.style,
        GoogleFonts.roboto(
          color: const Color(0xffffffff),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      );

      final professionalExperienceAssessmentRating = tester.widget<Text>(
        find.byKey(const Key('professionalExperienceAssessmentRating')),
      );
      expect(
        professionalExperienceAssessmentRating.style,
        GoogleFonts.roboto(
          color: const Color(0xff212121),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      );

      final voucherOverlay =
          tester.widget<Text>(find.byKey(const Key('voucherOverlay')));
      expect(
        voucherOverlay.style,
        GoogleFonts.roboto(
          color: const Color(0xffFFFFFF),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      );

      final ecole42LearningAchievementStudentIdentity = tester.widget<Text>(
        find.byKey(const Key('ecole42LearningAchievementStudentIdentity')),
      );
      expect(
        ecole42LearningAchievementStudentIdentity.style,
        GoogleFonts.roboto(
          color: const Color(0xff212121),
          fontSize: 6,
          fontWeight: FontWeight.w700,
        ),
      );

      final ecole42LearningAchievementLevel = tester.widget<Text>(
        find.byKey(const Key('ecole42LearningAchievementLevel')),
      );
      expect(
        ecole42LearningAchievementLevel.style,
        GoogleFonts.roboto(
          color: const Color(0xff212121),
          fontSize: 5,
          fontWeight: FontWeight.w700,
        ),
      );
    });
  });
}
