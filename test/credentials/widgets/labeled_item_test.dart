import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

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
  group('LabeledItem widget work properly', () {
    const label = 'label';
    const value = 'value';
    const hero = 'hero';
    const icon = '/assets/icon/location-target.svg';

    testWidgets('find svg image', (WidgetTester tester) async {
      await tester.pumpWidget(
        DefaultAssetBundle(
          bundle: FakeAssetBundle(),
          child: MaterialApp(
            home: Scaffold(
              body: LabeledItem(
                key: GlobalKey(),
                icon: icon,
                label: label,
                hero: hero,
                value: value,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(LabeledItem), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('verify tooltip and text exist', (WidgetTester tester) async {
      await tester.pumpWidget(
        DefaultAssetBundle(
          bundle: FakeAssetBundle(),
          child: const MaterialApp(
            home: Scaffold(
              body: LabeledItem(
                icon: icon,
                label: label,
                hero: hero,
                value: value,
              ),
            ),
          ),
        ),
      );
      expect(find.byTooltip('$label $value'), findsOneWidget);
      expect(find.text(value), findsOneWidget);
    });

    testWidgets('verify tooltip widget style', (WidgetTester tester) async {
      await tester.pumpWidget(
        DefaultAssetBundle(
          bundle: FakeAssetBundle(),
          child: MaterialApp(
            theme: AppTheme.lightThemeData,
            darkTheme: AppTheme.darkThemeData,
            home: const Scaffold(
              body: LabeledItem(
                icon: icon,
                label: label,
                hero: hero,
                value: value,
              ),
            ),
          ),
        ),
      );
      final BuildContext context = tester.element(find.byType(MaterialApp));
      final toolTipStyle = GoogleFonts.poppins(
        color: Theme.of(context).primaryColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );
      final toolTipWidget =
          tester.widget(find.byType(TooltipText)) as TooltipText;
      expect(
        toolTipWidget,
        isA<TooltipText>().having((p0) => p0.style, 'style', toolTipStyle),
      );
    });

    testWidgets('verify all widget exist', (WidgetTester tester) async {
      await tester.pumpWidget(
        DefaultAssetBundle(
          bundle: FakeAssetBundle(),
          child: const MaterialApp(
            home: Scaffold(
              body: LabeledItem(
                icon: icon,
                label: label,
                hero: hero,
                value: value,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(find.byType(SizedBox), findsNWidgets(3));
      expect(find.byType(Expanded), findsOneWidget);
      expect(find.byType(TooltipText), findsOneWidget);
    });

    testWidgets('verify SizedBox(width: 8) exist', (WidgetTester tester) async {
      await tester.pumpWidget(
        DefaultAssetBundle(
          bundle: FakeAssetBundle(),
          child: const MaterialApp(
            home: Scaffold(
              body: LabeledItem(
                icon: icon,
                label: label,
                hero: hero,
                value: value,
              ),
            ),
          ),
        ),
      );
      expect(
        find.byWidgetPredicate((widget) {
          return widget is SizedBox && widget.width == 8;
        }),
        findsOneWidget,
      );
    });
  });
}
