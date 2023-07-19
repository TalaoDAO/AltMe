import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  static Route<String?> route() => MaterialPageRoute<String?>(
        builder: (context) => const QrScannerPage(),
        settings: const RouteSettings(name: '/qrScannerPage'),
      );

  @override
  _QrScannerPageState createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final BarcodeScanner _barcodeScannerController =
      BarcodeScanner(formats: [BarcodeFormat.qrCode]);

  @override
  void dispose() {
    _barcodeScannerController.close();
    super.dispose();
  }

  bool isScanned = false;
  var _cameraLensDirection = CameraLensDirection.back;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      padding: EdgeInsets.zero,
      title: l10n.scanTitle,
      scrollView: false,
      extendBelow: true,
      titleLeading: const BackLeadingButton(),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: Sizes.appBarHeight),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox.square(
                dimension: MediaQuery.of(context).size.shortestSide * 0.8,
                child: QrCameraView(
                  onImage: (InputImage inputImage) async {
                    if (!isScanned) {
                      final barcodes = await _barcodeScannerController
                          .processImage(inputImage);
                      if (barcodes.isEmpty) {
                        return;
                      }

                      if (isScanned) return;
                      isScanned = true;

                      await _barcodeScannerController.close();
                      Navigator.of(context).pop(barcodes.first.rawValue);
                    }
                  },
                  initialCameraLensDirection: _cameraLensDirection,
                  onCameraLensDirectionChanged: (value) =>
                      _cameraLensDirection = value,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
