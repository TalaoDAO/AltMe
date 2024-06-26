import 'package:altme/app/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('BasePage', () {
    group('CustomAppBar', () {
      testWidgets(
          'does not renders CustomAppBar when title, titleTrailing and'
          ' titleLeading are null', (tester) async {
        await tester.pumpApp(
          BasePage(
            body: Container(),
            title: null,
            titleTrailing: null,
            titleLeading: null,
          ),
        );
        expect(find.byType(CustomAppBar), findsNothing);
      });

      testWidgets(
          'does not renders CustomAppBar when title, titleTrailing and'
          ' titleLeading are null and secure screen is true', (tester) async {
        await tester.pumpApp(
          BasePage(
            body: Container(),
            title: null,
            titleTrailing: null,
            titleLeading: null,
            secureScreen: true,
          ),
        );
        expect(find.byType(CustomAppBar), findsNothing);
      });

      testWidgets(
          'renders CustomAppBar when title is provided '
          'and secure screen is true', (tester) async {
        await tester.pumpApp(
          BasePage(
            body: Container(),
            title: 'I am title',
            secureScreen: true,
          ),
        );
        expect(find.byType(CustomAppBar), findsOneWidget);
      });

      testWidgets('renders CustomAppBar when title is provided',
          (tester) async {
        await tester.pumpApp(BasePage(body: Container(), title: 'I am title'));
        expect(find.byType(CustomAppBar), findsOneWidget);
      });
    });

    group('scrollView', () {
      testWidgets('renders SingleChildScrollView when scrollView is true',
          (tester) async {
        await tester.pumpApp(BasePage(body: Container(), scrollView: true));
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('renders Padding when scrollView is false', (tester) async {
        await tester.pumpApp(
          BasePage(
            body: Container(),
            scrollView: false,
            useSafeArea: false, //SafeArea also have nested Padding widget
          ),
        );
        expect(find.byType(Padding), findsOneWidget);
      });
    });

    group('useSafeArea', () {
      group('renders SafeArea correctly when useSafeArea is true ', () {
        testWidgets('navigation is provided', (tester) async {
          await tester.pumpApp(
            BasePage(
              body: Container(),
              useSafeArea: true,
              navigation: Container(),
            ),
          );
          expect(find.byType(SafeArea), findsNWidgets(2));
        });

        testWidgets('scrollView is true', (tester) async {
          await tester.pumpApp(
            BasePage(
              body: Container(),
              useSafeArea: true,
              scrollView: true,
            ),
          );
          expect(find.byType(SafeArea), findsOneWidget);
        });

        testWidgets('scrollView is false', (tester) async {
          await tester.pumpApp(
            BasePage(
              body: Container(),
              useSafeArea: true,
              scrollView: false,
            ),
          );
          expect(find.byType(SafeArea), findsOneWidget);
        });
        testWidgets('navigation is provided and secure screen is true',
            (tester) async {
          await tester.pumpApp(
            BasePage(
              body: Container(),
              useSafeArea: true,
              secureScreen: true,
              navigation: Container(),
            ),
          );
          expect(find.byType(SafeArea), findsNWidgets(2));
        });

        testWidgets('scrollView is true and secure screen is true',
            (tester) async {
          await tester.pumpApp(
            BasePage(
              body: Container(),
              useSafeArea: true,
              secureScreen: true,
              scrollView: true,
            ),
          );
          expect(find.byType(SafeArea), findsOneWidget);
        });

        testWidgets('scrollView is false and secure screen is true',
            (tester) async {
          await tester.pumpApp(
            BasePage(
              body: Container(),
              useSafeArea: true,
              scrollView: false,
              secureScreen: true,
            ),
          );
          expect(find.byType(SafeArea), findsOneWidget);
        });
      });

      group('renders SafeArea correctly when useSafeArea is false ', () {
        testWidgets(' navigation is provided', (tester) async {
          await tester.pumpApp(
            BasePage(
              body: Container(),
              useSafeArea: false,
              navigation: Container(),
            ),
          );
          expect(find.byType(SafeArea), findsNothing);
        });

        testWidgets('scrollView is true', (tester) async {
          await tester.pumpApp(
            BasePage(
              body: Container(),
              useSafeArea: false,
              scrollView: true,
            ),
          );
          expect(find.byType(SafeArea), findsNothing);
        });

        testWidgets('scrollView is false', (tester) async {
          await tester.pumpApp(
            BasePage(
              body: Container(),
              useSafeArea: false,
              scrollView: false,
            ),
          );
          expect(find.byType(SafeArea), findsNothing);
        });

        testWidgets('navigation is provided and secure screen is true',
            (tester) async {
          await tester.pumpApp(
            BasePage(
              body: Container(),
              useSafeArea: false,
              secureScreen: true,
              navigation: Container(),
            ),
          );
          expect(find.byType(SafeArea), findsNothing);
        });

        testWidgets('scrollView is true and secure screen is true',
            (tester) async {
          await tester.pumpApp(
            BasePage(
              body: Container(),
              useSafeArea: false,
              secureScreen: true,
              scrollView: true,
            ),
          );
          expect(find.byType(SafeArea), findsNothing);
        });

        testWidgets('scrollView is false and secure screen is true',
            (tester) async {
          await tester.pumpApp(
            BasePage(
              body: Container(),
              useSafeArea: false,
              scrollView: false,
              secureScreen: true,
            ),
          );
          expect(find.byType(SafeArea), findsNothing);
        });
      });
    });
  });
}
