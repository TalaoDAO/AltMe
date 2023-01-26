import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ReceivePage extends StatelessWidget {
  const ReceivePage({
    super.key,
    required this.accountAddress,
    required this.item,
    required this.description,
  });

  static Route<dynamic> route({
    required String accountAddress,
    required String item,
    required String description,
  }) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/receivePage'),
      builder: (_) => ReceivePage(
        accountAddress: accountAddress,
        item: item,
        description: description,
      ),
    );
  }

  final String accountAddress;
  final String item;
  final String description;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
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
                  '${l10n.receive} $item',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: Sizes.spaceXLarge,
                ),
                BackgroundCard(
                  padding: const EdgeInsets.all(Sizes.spaceNormal),
                  color: Theme.of(context).colorScheme.cardBackground,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: Sizes.spaceSmall,
                ),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall2,
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
