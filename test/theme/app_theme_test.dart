import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('Light CustomColorScheme', () {
    testWidgets('light color is rendered correctly', (tester) async {
      await tester.pumpApp(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Builder(
            builder: (context) => Column(
              children: [
                Container(
                  key: const Key('transparent'),
                  color: Theme.of(context).colorScheme.transparent,
                ),
                Container(
                  key: const Key('appBar'),
                  color: Theme.of(context).colorScheme.appBar,
                ),
                Container(
                  key: const Key('backButton'),
                  color: Theme.of(context).colorScheme.backButton,
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
                  key: const Key('button'),
                  color: Theme.of(context).colorScheme.button,
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
                  key: const Key('snackBarError'),
                  color: Theme.of(context).colorScheme.snackBarError,
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
      expect(appBar.color, const Color(0xffffffff));

      final backButton =
          tester.widget<Container>(find.byKey(const Key('backButton')));
      expect(backButton.color, const Color(0xFF1D1D1D));

      final selectedBottomBar =
          tester.widget<Container>(find.byKey(const Key('selectedBottomBar')));
      expect(selectedBottomBar.color, AppTheme.lightOnSurface);

      final borderColor =
          tester.widget<Container>(find.byKey(const Key('borderColor')));
      expect(borderColor.color, const Color(0xFFEEEAEA));

      final markDownH1 =
          tester.widget<Container>(find.byKey(const Key('markDownH1')));
      expect(markDownH1.color, AppTheme.lightOnSurface);

      final markDownH2 =
          tester.widget<Container>(find.byKey(const Key('markDownH2')));
      expect(markDownH2.color, AppTheme.lightOnSurface);

      final markDownP =
          tester.widget<Container>(find.byKey(const Key('markDownP')));
      expect(markDownP.color, AppTheme.lightOnSurface);

      final markDownA =
          tester.widget<Container>(find.byKey(const Key('markDownA')));
      expect(markDownA.color, const Color(0xff3700b3));

      final subtitle1 =
          tester.widget<Container>(find.byKey(const Key('subtitle1')));
      expect(subtitle1.color, const Color(0xff212121));

      final subtitle2 =
          tester.widget<Container>(find.byKey(const Key('subtitle2')));
      expect(subtitle2.color, const Color(0xff212121));

      final button = tester.widget<Container>(find.byKey(const Key('button')));
      expect(button.color, const Color(0xff212121));

      final profileDummy =
          tester.widget<Container>(find.byKey(const Key('profileDummy')));
      expect(profileDummy.color, const Color(0xFFE0E0E0));

      final documentShadow =
          tester.widget<Container>(find.byKey(const Key('documentShadow')));
      expect(documentShadow.color, const Color(0xFF757575));

      final documentShape =
          tester.widget<Container>(find.byKey(const Key('documentShape')));
      expect(
        documentShape.color,
        AppTheme.lightPrimaryContainer.withOpacity(0.5),
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

      final snackBarError =
          tester.widget<Container>(find.byKey(const Key('snackBarError')));
      expect(snackBarError.color, Colors.red);

      final buttonDisabled =
          tester.widget<Container>(find.byKey(const Key('buttonDisabled')));
      expect(buttonDisabled.color, const Color(0xFFADACAC));
    });
  });
}
