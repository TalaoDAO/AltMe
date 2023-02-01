import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/scan/scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanPage extends StatefulWidget {
  const QrCodeScanPage({super.key});

  static Route<dynamic> route() => MaterialPageRoute<void>(
        builder: (context) => const QrCodeScanPage(),
        settings: const RouteSettings(name: '/qrCodeScanPage'),
      );

  @override
  _QrCodeScanPageState createState() => _QrCodeScanPageState();
}

class _QrCodeScanPageState extends State<QrCodeScanPage> {
  final qrKey = GlobalKey(debugLabel: 'QR');

  MobileScannerController scannerController = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
  );

  bool isScanned = false;

  @override
  void dispose() {
    super.dispose();
    scannerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MultiBlocListener(
      listeners: [
        BlocListener<QRCodeScanCubit, QRCodeScanState>(
          listener: (context, state) async {
            if (state.status == QrScanStatus.error) {
              if (state.message != null) {
                Navigator.of(context).pop();
              }
            }

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
          },
        ),
      ],
      child: BasePage(
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
                    controller: scannerController,
                    onDetect: (capture) {
                      final List<Barcode> qrcodes = capture.barcodes;
                      final Barcode qrcode = qrcodes[0];
                      for (final barcode in qrcodes) {
                        debugPrint('Barcode found! ${barcode.rawValue}');
                      }
                      if (qrcode.rawValue == null) {
                        context.read<QRCodeScanCubit>().emitError(
                              ResponseMessage(
                                ResponseString
                                    .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER, // ignore: lines_longer_than_80_chars
                              ),
                            );
                      } else {
                        if (!isScanned) {
                          isScanned = true;
                          final String code = qrcode.rawValue!;
                          context
                              .read<QRCodeScanCubit>()
                              .process(scannedResponse: code);
                          scannerController.stop();
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
