import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({Key? key}) : super(key: key);

  static Route<String?> route() => MaterialPageRoute<String?>(
        builder: (context) => const QrScannerPage(),
        settings: const RouteSettings(name: '/qrScannerPage'),
      );

  @override
  _QrScannerPageState createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> scanQR() async {
    try {
      final barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      Navigator.of(context).pop(barcodeScanRes);
    } on PlatformException catch (e, s) {
      getLogger(runtimeType.toString()).e('error: $e, stack: $s');
    }
  }

  @override
  void initState() {
    scanQR();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
