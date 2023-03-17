import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
  final qrKey = GlobalKey(debugLabel: 'TokenQR');

  MobileScannerController scannerController = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
  );

  @override
  void dispose() {
    super.dispose();
    scannerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      padding: EdgeInsets.zero,
      title: l10n.scanTitle,
      scrollView: false,
      extendBelow: true,
      titleLeading: const BackLeadingButton(),
      titleTrailing: IconButton(
        color: Colors.white,
        icon: ValueListenableBuilder(
          valueListenable: scannerController.torchState,
          builder: (context, state, child) {
            switch (state) {
              case TorchState.off:
                return const Icon(Icons.flash_off, color: Colors.grey);
              case TorchState.on:
                return const Icon(Icons.flash_on, color: Colors.yellow);
            }
          },
        ),
        iconSize: 32,
        onPressed: () => scannerController.toggleTorch(),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: Sizes.appBarHeight),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox.square(
                dimension: MediaQuery.of(context).size.shortestSide * 0.8,
                child: MobileScanner(
                  key: qrKey,
                  fit: BoxFit.cover,
                  controller: scannerController,
                  allowDuplicates: false,
                  onDetect: (qrcode, args) {
                    if (qrcode.rawValue == null) {
                      Navigator.of(context).pop();
                    } else {
                      final String code = qrcode.rawValue!;
                      scannerController.stop();
                      Navigator.of(context).pop(code);
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
