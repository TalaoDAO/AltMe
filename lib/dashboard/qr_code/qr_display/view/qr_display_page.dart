import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeDisplayPage extends StatelessWidget {
  const QrCodeDisplayPage({
    super.key,
    required this.title,
    required this.data,
  });

  final String title;
  final String data;

  static Route<dynamic> route({required String title, required String data}) =>
      MaterialPageRoute<void>(
        builder: (context) => QrCodeDisplayPage(data: data, title: title),
        settings: const RouteSettings(name: '/QrCodeDisplayPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: title,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      scrollView: false,
      body: BackgroundCard(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: QrImage(
                data: data,
                size: 200,
                foregroundColor: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 10),
            CopyButton(
              onTap: () async {
                await Clipboard.setData(
                  ClipboardData(text: data),
                );
                AlertMessage.showStateMessage(
                  context: context,
                  stateMessage: StateMessage.success(
                    stringMessage: l10n.copiedToClipboard,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
