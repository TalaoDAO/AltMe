import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QrCodeScanPage extends StatefulWidget {
  const QrCodeScanPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => const QrCodeScanPage(),
        settings: const RouteSettings(name: '/qrCodeScanPage'),
      );

  @override
  _QrCodeScanPageState createState() => _QrCodeScanPageState();
}

class _QrCodeScanPageState extends State<QrCodeScanPage> {
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> scanQR() async {
    String? barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
    } on PlatformException {
      await context.read<QRCodeScanCubit>().emitError(
            ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER, // ignore: lines_longer_than_80_chars
            ),
          );
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    if (barcodeScanRes == null) {
      await context.read<QRCodeScanCubit>().emitError(
            ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER, // ignore: lines_longer_than_80_chars
            ),
          );
    } else {
      await context
          .read<QRCodeScanCubit>()
          .process(scannedResponse: barcodeScanRes);
    }
    // Navigator.of(context).pop();
  }

  @override
  void initState() {
    scanQR();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QRCodeScanCubit, QRCodeScanState>(
      listener: (context, state) async {
        if (state.status == QrScanStatus.error ||
            state.status == QrScanStatus.message) {
          if (state.message != null) {
            Navigator.of(context).pop();
          }
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
