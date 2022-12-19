import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class AccountPublicAddressPage extends StatelessWidget {
  const AccountPublicAddressPage({
    Key? key,
    required this.accountName,
    required this.accountAddress,
  }) : super(key: key);

  static Route route({
    required String accountName,
    required String accountAddress,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => AccountPublicAddressPage(
        accountName: accountName,
        accountAddress: accountAddress,
      ),
      settings: const RouteSettings(name: '/AccountPublicAddressPage'),
    );
  }

  final String accountName;
  final String accountAddress;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.publicAddress,
      titleAlignment: Alignment.topCenter,
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
                  accountName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: Sizes.spaceXLarge,
                ),
                Container(
                  padding: const EdgeInsets.all(Sizes.spaceSmall),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        Sizes.normalRadius,
                      ),
                    ),
                  ),
                  child: QrImage(
                    data: accountAddress,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: Sizes.spaceNormal,
                ),
                Text(
                  accountAddress,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                ),
                const SizedBox(
                  height: Sizes.spaceXLarge,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CopyButton(
                      onTap: () async {
                        await Clipboard.setData(
                          ClipboardData(
                            text: accountAddress,
                          ),
                        );
                        AlertMessage.showStateMessage(
                          context: context,
                          stateMessage: StateMessage.success(
                            stringMessage: l10n.copiedToClipboard,
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      width: Sizes.space2XLarge,
                    ),
                    ShareButton(
                      onTap: () {
                        final box = context.findRenderObject() as RenderBox?;
                        final subject = l10n.shareWith;

                        Share.share(
                          accountAddress,
                          subject: subject,
                          sharePositionOrigin:
                              box!.localToGlobal(Offset.zero) & box.size,
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
