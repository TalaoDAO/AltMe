import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Scans a QR code and pops with its raw value.
class QrScannerPage extends StatelessWidget {
  const QrScannerPage({super.key});

  static Route<String?> route() => MaterialPageRoute<String?>(
    builder: (context) => const QrScannerPage(),
    settings: const RouteSettings(name: '/qrScannerPage'),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final background = Theme.of(context).colorScheme.surface;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(
          l10n.scanTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: const BackLeadingButton(),
        backgroundColor: background,
      ),
      body: QrScannerView(onScan: (value) => Navigator.of(context).pop(value)),
    );
  }
}
