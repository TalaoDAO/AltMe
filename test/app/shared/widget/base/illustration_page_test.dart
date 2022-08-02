import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAssetBundle extends Fake implements AssetBundle {
  final svgStr = '''
  <?xml version="1.0" encoding="UTF-8"?>
<svg width="36.536" height="36.536" version="1.1" viewBox="0 0 36.536 36.536"
    xmlns="http://www.w3.org/2000/svg">
    <g transform="translate(-.25356 -260.21)" fill="none" stroke="#000" stroke-linecap="round"
        stroke-width="2.5">
        <circle cx="18.5" cy="278.5" r="12" stroke-linejoin="round"
            style="paint-order:fill markers stroke" />
        <circle cx="18.5" cy="278.5" r="5" stroke-linejoin="round"
            style="paint-order:fill markers stroke" />
        <g>
            <path d="m18.5 265.48v-4" />
            <path d="m18.5 295.48v-4" />
            <path d="m31.521 278.5h4" />
            <path d="m1.5214 278.5h4" />
        </g>
    </g>
</svg>
''';

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    return svgStr;
  }
}

void main() {
  Widget makeTestableWidget() {
    return DefaultAssetBundle(
      bundle: FakeAssetBundle(),
      child: MaterialApp(
        home: BaseIllustrationPage(
          asset: 'asset',
          action: 'action',
          description: 'description',
          backgroundColor: Colors.blueGrey,
          onPressed: () {},
        ),
      ),
    );
  }

  group('IllustrationPage widget', () {
    testWidgets('all sub widgets founded', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(),
      );
      expect(find.byType(BaseIllustrationPage), findsOneWidget);
      expect(find.byType(BasePage), findsOneWidget);
      expect(find.byType(MyElevatedButton), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('verify property of widget set correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(),
      );
      expect(find.byType(BaseIllustrationPage), findsOneWidget);
      final baseIllustrationPage = tester
          .widget<BaseIllustrationPage>(find.byType(BaseIllustrationPage));
      expect(baseIllustrationPage.asset, 'asset');
      expect(baseIllustrationPage.action, 'action');
      expect(baseIllustrationPage.description, 'description');
      expect(baseIllustrationPage.backgroundColor, Colors.blueGrey);
      expect(baseIllustrationPage.onPressed, isNotNull);
    });
  });
}
