import 'package:altme/app/app.dart';
import 'package:altme/dashboard/drawer/manage_did/view/did_private_key_page.dart';
import 'package:altme/dashboard/drawer/manage_did/widgets/widgets.dart';
import 'package:altme/did/did.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageDIDPage extends StatelessWidget {
  const ManageDIDPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const ManageDIDPage());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.publicAddress,
      scrollView: false,
      titleLeading: const BackLeadingButton(),
      body: BackgroundCard(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              l10n.didKey,
              style: Theme.of(context).textTheme.title,
            ),
            const SizedBox(
              height: Sizes.spaceNormal,
            ),
            Text(
              context.read<DIDCubit>().state.did ?? '...',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Padding(
              padding: const EdgeInsets.all(Sizes.spaceXLarge),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CopyButton(
                    onTap: () async {
                      await Clipboard.setData(
                        ClipboardData(
                          text: context.read<DIDCubit>().state.did ?? '...',
                        ),
                      );
                      AlertMessage.showStringMessage(
                        context: context,
                        message: l10n.copyDIDKeyToClipboard,
                        messageType: MessageType.success,
                      );
                    },
                  ),
                  const SizedBox(
                    width: Sizes.spaceXLarge,
                  ),
                  const ExportButton(),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.spaceNormal),
              child: Divider(),
            ),
            const SizedBox(
              height: Sizes.space2XLarge,
            ),
            Text(
              l10n.didPrivateKey,
              style: Theme.of(context).textTheme.title,
            ),
            const SizedBox(
              height: Sizes.spaceNormal,
            ),
            Text(
              l10n.didPrivateKeyDescription,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(
              height: Sizes.spaceXLarge,
            ),
            RevealButton(
              onTap: () {
                DIDPrivateKeyDialog.show(
                  context: context,
                  onContinueClick: () {
                    Navigator.of(context).push<void>(
                      PinCodePage.route(
                        restrictToBack: false,
                        isValidCallback: () {
                          Navigator.push<void>(
                            context,
                            DIDPrivateKeyPage.route(),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
