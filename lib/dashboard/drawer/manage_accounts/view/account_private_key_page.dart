import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountPrivateKeyPage extends StatelessWidget {
  const AccountPrivateKeyPage({
    Key? key,
    required this.privateKey,
  }) : super(key: key);

  static Route route({
    required String privateKey,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => AccountPrivateKeyPage(
        privateKey: privateKey,
      ),
    );
  }

  final String privateKey;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.privateKey,
      scrollView: false,
      titleLeading: const BackLeadingButton(),
      body: BackgroundCard(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.spaceNormal),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  privateKey,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                ),
                const SizedBox(
                  height: Sizes.spaceXLarge,
                ),
                CopyButton(
                  onTap: () async {
                    await Clipboard.setData(
                      ClipboardData(
                        text: privateKey,
                      ),
                    );
                    AlertMessage.showStringMessage(
                      context: context,
                      message: l10n.copiedToClipboard,
                      messageType: MessageType.success,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
