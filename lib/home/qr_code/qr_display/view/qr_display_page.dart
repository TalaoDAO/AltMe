import 'package:altme/app/app.dart';
import 'package:altme/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeDisplayPage extends StatelessWidget {
  const QrCodeDisplayPage({
    Key? key,
    required this.name,
    required this.data,
  }) : super(key: key);

  final String name;
  final CredentialModel data;

  static Route route(String name, CredentialModel data) =>
      MaterialPageRoute<void>(
        builder: (context) => QrCodeDisplayPage(name: name, data: data),
        settings: const RouteSettings(name: '/qrCodeDisplay'),
      );

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: ' ',
      titleLeading: const BackLeadingButton(),
      scrollView: false,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(32),
                child: QrImage(
                  data: data.shareLink,
                  version: QrVersions.auto,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
