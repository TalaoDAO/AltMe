import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/mdoc_proximity/widgets/proximity_message.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

/// The camera preview, handing the first QR code it reads to [onScan].
///
/// The [MobileScanner] owns its camera: it starts it, pauses it with the app
/// lifecycle and releases it when this view leaves the tree.
class QrScannerView extends StatefulWidget {
  /// Creates the view.
  const QrScannerView({required this.onScan, super.key});

  /// Called once, with the raw value of the first QR code read.
  final ValueChanged<String> onScan;

  @override
  State<QrScannerView> createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<QrScannerView> {
  var _scanned = false;

  /// Bumped by "try again" to rebuild the scanner, which starts the camera
  /// again, e.g. after the permission was granted in the settings.
  var _attempt = 0;

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;
      if (barcode.format == BarcodeFormat.qrCode && value != null) {
        _scanned = true;
        widget.onScan(value);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).colorScheme.surface;
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final side = size.shortestSide * scanWindowRatio;
        return MobileScanner(
          key: ValueKey(_attempt),
          onDetect: _onDetect,
          scanWindow: Rect.fromCenter(
            center: size.center(Offset.zero),
            width: side,
            height: side,
          ),
          placeholderBuilder: (_) => ColoredBox(color: background),
          errorBuilder: (context, error) => ColoredBox(
            color: background,
            child: _ScannerError(
              error: error,
              onTryAgain: () => setState(() => _attempt++),
            ),
          ),
          overlayBuilder: (_, _) =>
              const SizedBox.expand(child: CustomPaint(painter: BlurPainter())),
        );
      },
    );
  }
}

/// The share of the preview's shortest side taken by the scan window.
const scanWindowRatio = 0.8;

class _ScannerError extends StatelessWidget {
  const _ScannerError({required this.error, required this.onTryAgain});

  final MobileScannerException error;
  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final permissionDenied =
        error.errorCode == MobileScannerErrorCode.permissionDenied;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ProximityMessage(
        icon: Icons.no_photography_outlined,
        text: permissionDenied
            ? l10n.qrScannerCameraPermission
            : l10n.somethingsWentWrongTryAgainLater,
        detail: permissionDenied ? null : error.errorDetails?.message,
        actions: [
          if (permissionDenied)
            MyOutlinedButton(
              text: l10n.mdocProximityOpenSettings,
              onPressed: openAppSettings,
            ),
          MyElevatedButton(text: l10n.tryAgain, onPressed: onTryAgain),
        ],
      ),
    );
  }
}

/// Darkens the preview around the centered scan window.
class BlurPainter extends CustomPainter {
  /// Creates the painter.
  const BlurPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final side = size.shortestSide * scanWindowRatio;
    final window = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: side,
      height: side,
    );
    final path = Path.combine(
      PathOperation.difference,
      Path()..addRect(Offset.zero & size),
      Path()..addRect(window),
    );
    canvas.drawPath(path, Paint()..color = Colors.black.withValues(alpha: 0.5));
  }

  @override
  bool shouldRepaint(covariant BlurPainter oldDelegate) => false;
}
