import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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
  final qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController qrController;

  bool isQrCodeScanned = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    qrController.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrController.pauseCamera();
    } else if (Platform.isIOS) {
      qrController.resumeCamera();
    }
  }

  void onQRViewCreated(QRViewController controller) {
    qrController = controller;
    qrController.scannedDataStream.listen((scanData) {
      qrController.pauseCamera();
      if (scanData.code is String && !isQrCodeScanned) {
        isQrCodeScanned = true;
        context.read<QRCodeScanCubit>().host(url: scanData.code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<QRCodeScanCubit, QRCodeScanState>(
      listener: (context, state) async {
        if (state.status == QrScanStatus.success) {
          if (state.route != null) {
            await qrController.stopCamera();
          }
        }
        if (state.status == QrScanStatus.error) {
          if (state.message != null) {
            await qrController.resumeCamera();
            isQrCodeScanned = false;
          }
        }
      },
      child: BasePage(
        padding: EdgeInsets.zero,
        title: l10n.scanTitle,
        scrollView: false,
        extendBelow: true,
        titleLeading: const BackLeadingButton(),
        body: SafeArea(
          child: QRView(
            key: qrKey,
            overlay: QrScannerOverlayShape(borderColor: Colors.white70),
            onQRViewCreated: onQRViewCreated,
          ),
        ),
      ),
    );
  }
}
