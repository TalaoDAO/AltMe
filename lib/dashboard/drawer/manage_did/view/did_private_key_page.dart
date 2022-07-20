import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class DIDPrivateKeyPage extends StatelessWidget {
  const DIDPrivateKeyPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const DIDPrivateKeyPage());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
        scrollView: false,
        title: l10n.decentralizedIDKey,
        titleLeading: const BackLeadingButton(),
        body: BackgroundCard(
          width: double.infinity,
          height: double.infinity,
          child: Text('DID private key page'),
        ));
  }
}
