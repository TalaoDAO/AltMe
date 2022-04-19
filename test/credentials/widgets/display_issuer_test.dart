import 'package:altme/app/shared/models/author/author.dart';
import 'package:altme/app/shared/widget/image_from_network/image_from_network.dart';
import 'package:altme/credentials/widgets/display_issuer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../app/shared/widget/image_from_network/image_from_network_test.dart';

void main() {

  group('DisplayIssuer Widget work correctly', () {

    late Author issuerWithLogo;
    late Author issuerWithoutLogo;
    const authorName = 'Taleb';
    const authorLogo = 'https://www.toto.fr';

    setUp(() {
      issuerWithLogo = Author(authorName, authorLogo);
      issuerWithoutLogo = Author(authorName, '');
    });

    mockNetworkImages(() async {
      testWidgets('find issuer name', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DisplayIssuer(issuer: issuerWithLogo),
          ),
        );
        expect(find.text(authorName), findsOneWidget);
      });

      testWidgets('find issuer model', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DisplayIssuer(issuer: issuerWithLogo),
          ),
        );
        final displayIssuer =
            tester.widget(find.byType(DisplayIssuer)) as DisplayIssuer;
        expect(displayIssuer.issuer, issuerWithLogo);
      });

      testWidgets('find ImageFromNetwork', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DisplayIssuer(issuer: issuerWithLogo),
          ),
        );
        expect(find.byType(ImageFromNetwork), findsOneWidget);
      });

      testWidgets('ImageFromNetwork gone when logo is empty',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DisplayIssuer(issuer: issuerWithoutLogo),
          ),
        );
        expect(find.byType(ImageFromNetwork), findsNothing);
      });

      testWidgets('find all widget', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DisplayIssuer(issuer: issuerWithLogo),
          ),
        );
        expect(find.byType(Padding), findsOneWidget);
        expect(find.byType(ImageFromNetwork), findsOneWidget);
        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
        expect(find.byType(Spacer), findsOneWidget);
        expect(find.byType(SizedBox), findsNWidgets(2));
      });
    });
  });
}
