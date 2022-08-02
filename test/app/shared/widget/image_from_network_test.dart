import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  const networkImageUrl = 'https://www.demo.com';
  final widgetKey = GlobalKey();

  Widget makeTestableWidget() => MaterialApp(
        home: CachedImageFromNetwork(
          networkImageUrl,
          key: widgetKey,
        ),
      );

  testWidgets('find Image Widget by key', (tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(makeTestableWidget());
      expect(find.byKey(widgetKey), findsOneWidget);
    });
  });

  testWidgets('find Image widget by Type', (tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(makeTestableWidget());
      expect(find.byType(Image), findsOneWidget);
    });
  });

  testWidgets('verify all property is correct', (tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(makeTestableWidget());
      final imageFromNetwork = tester
          .widget<CachedImageFromNetwork>(find.byType(CachedImageFromNetwork));
      expect(imageFromNetwork.url, networkImageUrl);
      expect(imageFromNetwork.fit, null);
      expect(imageFromNetwork.key, widgetKey);
    });
  });

  testWidgets('get SizedBox on errorBuilder', (tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(makeTestableWidget());
      final image = tester.widget<Image>(find.byType(Image));
      final BuildContext context = tester.element(find.byType(MaterialApp));
      final result = image.errorBuilder?.call(
        context,
        Object(),
        StackTrace.fromString('stackTraceString'),
      );
      expect(result, isA<SizedBox>());
    });
  });
}
