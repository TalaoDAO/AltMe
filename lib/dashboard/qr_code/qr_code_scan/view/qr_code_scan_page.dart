import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/route/route_name.dart';
import 'package:altme/scan/scan.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class QrCodeScanPage extends StatefulWidget {
  const QrCodeScanPage({super.key});

  static Route<dynamic> route() => MaterialPageRoute<void>(
        builder: (context) => const QrCodeScanPage(),
        settings: const RouteSettings(name: QRCODE_SCAN_PAGE),
      );

  @override
  _QrCodeScanPageState createState() => _QrCodeScanPageState();
}

class _QrCodeScanPageState extends State<QrCodeScanPage> {
  final BarcodeScanner _barcodeScannerController =
      BarcodeScanner(formats: [BarcodeFormat.qrCode]);

  @override
  void dispose() {
    _barcodeScannerController.close();
    super.dispose();
  }

  bool isScanned = false;
  bool isFirstImage = true;
  var _cameraLensDirection = CameraLensDirection.back;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MultiBlocListener(
      listeners: [
        BlocListener<QRCodeScanCubit, QRCodeScanState>(
          listener: (context, state) async {
            if (state.status == QrScanStatus.goBack) {
              Navigator.of(context).pop();
            }
          },
        ),
        BlocListener<ScanCubit, ScanState>(
          listener: (context, state) {
            if (state.status == ScanStatus.loading) {
              LoadingView().show(context: context);
            } else {
              LoadingView().hide();
            }
            if (state.status == ScanStatus.success && state.message != null) {
              AlertMessage.showStateMessage(
                context: context,
                stateMessage: state.message!,
              );
            }
          },
        ),
      ],
      child: QrCameraView(
        title: l10n.scanTitle,
        onImage: (InputImage inputImage) async {
          if (!isScanned) {
            final barcodes =
                await _barcodeScannerController.processImage(inputImage);
            if (barcodes.isEmpty) {
              return;
            }
            if (isFirstImage) {
              isFirstImage = false;
              return;
            }

            if (isScanned) return;
            isScanned = true;

            await context
                .read<QRCodeScanCubit>()
                .process(scannedResponse: barcodes.first.rawValue);
          }
        },
        initialCameraLensDirection: _cameraLensDirection,
        onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
      ),
    );
  }
}


//qr is scanning twice
