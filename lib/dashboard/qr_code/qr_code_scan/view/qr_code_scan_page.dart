import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/mdoc_proximity/mdoc_proximity.dart';
import 'package:altme/route/route_name.dart';
import 'package:altme/scan/scan.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';

/// The tabs of [QrCodeScanPage].
enum ScanPageTab {
  /// Scan a QR code.
  scan,

  /// Show a reader the in-person engagement QR code.
  present,

  /// Read a holder in person. Only with the profile's reader requests.
  read,
}

class QrCodeScanPage extends StatefulWidget {
  const QrCodeScanPage({super.key, this.initialTab = ScanPageTab.scan});

  /// The tab shown first.
  final ScanPageTab initialTab;

  static Route<dynamic> route({ScanPageTab initialTab = ScanPageTab.scan}) =>
      MaterialPageRoute<void>(
        builder: (context) => QrCodeScanPage(initialTab: initialTab),
        settings: const RouteSettings(name: QRCODE_SCAN_PAGE),
      );

  @override
  _QrCodeScanPageState createState() => _QrCodeScanPageState();
}

class _QrCodeScanPageState extends State<QrCodeScanPage> {
  late ScanPageTab _tab = widget.initialTab;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final readerRequests = context.select<ProfileCubit, List<ReaderRequest>>(
      (cubit) => cubit.state.model.profileSetting.readerRequests ?? const [],
    );
    final tabs = [
      ScanPageTab.scan,
      ScanPageTab.present,
      if (readerRequests.isNotEmpty) ScanPageTab.read,
    ];
    final tab = tabs.contains(_tab) ? _tab : ScanPageTab.scan;

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
      child: BasePage(
        title: switch (tab) {
          ScanPageTab.scan => l10n.scanTitle,
          ScanPageTab.present => l10n.mdocProximityTitle,
          ScanPageTab.read => l10n.mdocReaderRequestsTitle,
        },
        titleAlignment: Alignment.topCenter,
        titleLeading: const BackLeadingButton(),
        scrollView: false,
        padding: EdgeInsets.zero,
        // The Present tab shows the data a reader asks for.
        secureScreen: true,
        body: Column(
          children: [
            Row(
              children: [
                for (final candidate in tabs)
                  Expanded(
                    child: CredentialDetailTabbar(
                      isSelected: candidate == tab,
                      title: switch (candidate) {
                        ScanPageTab.scan => l10n.scanTabScan,
                        ScanPageTab.present => l10n.mdocPresent,
                        ScanPageTab.read => l10n.mdocReaderRequestsTitle,
                      },
                      icon: switch (candidate) {
                        ScanPageTab.scan => Icons.qr_code_scanner,
                        ScanPageTab.present => Icons.contactless_outlined,
                        ScanPageTab.read => Icons.fact_check_outlined,
                      },
                      onTap: () => setState(() => _tab = candidate),
                    ),
                  ),
              ],
            ),
            Divider(
              height: 0,
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
            ),
            Expanded(
              child: switch (tab) {
                ScanPageTab.scan => const _QrCodeScanView(),
                ScanPageTab.present => const Padding(
                  padding: EdgeInsets.all(16),
                  child: MdocPresentView(),
                ),
                ScanPageTab.read => Padding(
                  padding: const EdgeInsets.all(16),
                  child: MdocReaderRequestsView(requests: readerRequests),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// The camera, handing the first QR code it reads to [QRCodeScanCubit].
class _QrCodeScanView extends StatefulWidget {
  const _QrCodeScanView();

  @override
  State<_QrCodeScanView> createState() => _QrCodeScanViewState();
}

class _QrCodeScanViewState extends State<_QrCodeScanView> {
  final BarcodeScanner _barcodeScannerController = BarcodeScanner(
    formats: [BarcodeFormat.qrCode],
  );

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
    return QrCameraView(
      onImage: (InputImage inputImage) async {
        if (!isScanned) {
          final barcodes = await _barcodeScannerController.processImage(
            inputImage,
          );
          if (barcodes.isEmpty) {
            return;
          }

          /// We are skiping the first image because android device get
          /// last image from previous camera usage
          if (isFirstImage) {
            isFirstImage = false;
            return;
          }

          if (isScanned) return;
          isScanned = true;

          await context.read<QRCodeScanCubit>().process(
            scannedResponse: barcodes.first.rawValue,
          );
        }
      },
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
    );
  }
}

//qr is scanning twice
