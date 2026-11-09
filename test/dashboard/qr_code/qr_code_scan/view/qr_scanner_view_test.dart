import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../helpers/helpers.dart';

void main() {
  late FakeMobileScannerPlatform platform;

  setUp(() => platform = FakeMobileScannerPlatform.install());

  group('QrScannerView', () {
    testWidgets('hands over the first QR code only once', (tester) async {
      final scans = <String>[];
      await tester.pumpApp(Scaffold(body: QrScannerView(onScan: scans.add)));
      await tester.pumpAndSettle();
      expect(platform.starts, 1);

      platform.barcodes.add(
        const BarcodeCapture(
          barcodes: [
            Barcode(format: BarcodeFormat.ean13, rawValue: '4006381333931'),
          ],
        ),
      );
      platform
        ..readQrCode('openid4vp://a')
        ..readQrCode('openid4vp://b');
      await tester.pumpAndSettle();

      expect(scans, ['openid4vp://a']);
      await unmountScanner(tester);
    });

    testWidgets('releases the camera when it leaves the tree', (tester) async {
      await tester.pumpApp(Scaffold(body: QrScannerView(onScan: (_) {})));
      await tester.pumpAndSettle();

      await unmountScanner(tester);

      expect(platform.stops, 1);
      expect(platform.disposes, 1);
    });

    testWidgets('asks for the camera permission and starts again', (
      tester,
    ) async {
      platform.startError = const MobileScannerException(
        errorCode: MobileScannerErrorCode.permissionDenied,
      );
      await tester.pumpApp(Scaffold(body: QrScannerView(onScan: (_) {})));
      await tester.pumpAndSettle();

      expect(
        find.text('Allow camera access to scan QR codes.'),
        findsOneWidget,
      );
      expect(find.text('OPEN SETTINGS'), findsOneWidget);

      platform.startError = null;
      await tester.tap(find.text('TRY AGAIN'));
      await tester.pumpAndSettle();

      expect(platform.starts, 2);
      expect(find.text('Allow camera access to scan QR codes.'), findsNothing);
      await unmountScanner(tester);
    });

    testWidgets('reports other camera errors', (tester) async {
      platform.startError = const MobileScannerException(
        errorCode: MobileScannerErrorCode.genericError,
        errorDetails: MobileScannerErrorDetails(message: 'camera busy'),
      );
      await tester.pumpApp(Scaffold(body: QrScannerView(onScan: (_) {})));
      await tester.pumpAndSettle();

      expect(find.text('camera busy'), findsOneWidget);
      expect(find.text('OPEN SETTINGS'), findsNothing);
      await unmountScanner(tester);
    });
  });
}
