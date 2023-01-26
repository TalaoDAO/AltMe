import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CredentialQrPage extends StatelessWidget {
  const CredentialQrPage({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  static Route<dynamic> route(CredentialModel credentialModel) =>
      MaterialPageRoute<void>(
        builder: (context) =>
            CredentialQrPage(credentialModel: credentialModel),
        settings: const RouteSettings(name: '/CredentialQrPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final String data = jsonEncode(credentialModel.data);

    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final String prettyprint = encoder.convert(credentialModel.data);

    return BasePage(
      title: credentialModel
          .credentialPreview.credentialSubjectModel.credentialSubjectType.name,
      titleLeading: const BackLeadingButton(),
      scrollView: true,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: data));
                    },
                    child: Text(
                      l10n.copyToClipboard,
                      style: Theme.of(context).textTheme.copyToClipBoard,
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceSmall),
                  Text(
                    prettyprint,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
