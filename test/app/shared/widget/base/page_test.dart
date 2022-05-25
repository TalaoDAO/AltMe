import 'package:altme/app/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('BasePage', () {
    group('CustomAppBar', () {
      testWidgets('does not renders CustomAppBar when title is null',
          (tester) async {
        await tester.pumpApp(BasePage(body: Container(), title: ''));
        expect(find.byType(CustomAppBar), findsNothing);
      });

      testWidgets('does not renders CustomAppBar when title is empty',
          (tester) async {
        await tester.pumpApp(BasePage(body: Container(), title: ''));
        expect(find.byType(CustomAppBar), findsNothing);
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
      testWidgets('renders SafeArea when useSafeArea is true', (tester) async {
        await tester.pumpApp(BasePage(body: Container(), useSafeArea: true));
        expect(find.byType(SafeArea), findsOneWidget);
      });

      testWidgets('does not renders SafeArea when useSafeArea is false',
          (tester) async {
        await tester.pumpApp(BasePage(body: Container(), useSafeArea: false));
        expect(find.byType(SafeArea), findsNothing);
      });
    });
  });
}
