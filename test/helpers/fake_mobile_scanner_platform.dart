import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Stands in for the native scanner of `mobile_scanner`.
///
/// [start] succeeds, or throws [startError]; [barcodes] feeds the scanner's
/// barcode stream. Install it with `install`, which restores the previous
/// platform when the test ends.
class FakeMobileScannerPlatform extends MobileScannerPlatform {
  /// Creates the fake and makes it the scanner platform for this test.
  factory FakeMobileScannerPlatform.install() {
    final original = MobileScannerPlatform.instance;
    final platform = FakeMobileScannerPlatform._();
    MobileScannerPlatform.instance = platform;
    addTearDown(() async {
      MobileScannerPlatform.instance = original;
      await platform.barcodes.close();
    });
    return platform;
  }

  FakeMobileScannerPlatform._();

  /// The barcodes the scanner reads.
  final barcodes = StreamController<BarcodeCapture?>.broadcast();

  /// Thrown by the next [start], when set.
  MobileScannerException? startError;

  /// How many times the camera was started.
  int starts = 0;

  /// How many times the camera was stopped.
  int stops = 0;

  /// How many times the camera was released.
  int disposes = 0;

  /// Reads a QR code holding [value].
  void readQrCode(String value) => barcodes.add(
    BarcodeCapture(
      barcodes: [Barcode(format: BarcodeFormat.qrCode, rawValue: value)],
    ),
  );

  @override
  Stream<BarcodeCapture?> get barcodesStream => barcodes.stream;

  @override
  Stream<TorchState> get torchStateStream => const Stream.empty();

  @override
  Stream<double> get zoomScaleStateStream => const Stream.empty();

  @override
  Widget buildCameraView() => const SizedBox.shrink();

  @override
  Future<MobileScannerViewAttributes> start(StartOptions startOptions) async {
    starts++;
    if (startError case final error?) throw error;
    return const MobileScannerViewAttributes(
      cameraDirection: CameraFacing.back,
      currentTorchMode: TorchState.unavailable,
      size: Size(720, 1280),
    );
  }

  @override
  Future<void> stop() async => stops++;

  @override
  Future<void> updateScanWindow(Rect? window) async {}

  @override
  Future<void> dispose() async => disposes++;
}

/// Removes the widget tree and lets the scanner release the camera inside the
/// test.
///
/// The release continues on futures completed outside the test's fake async
/// zone, and mobile_scanner serializes camera sessions behind a static lock:
/// a release left pending by the framework's own teardown would block the next
/// test's start.
Future<void> unmountScanner(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.runAsync(() => Future<void>.delayed(Duration.zero));
  await tester.pumpAndSettle();
}
