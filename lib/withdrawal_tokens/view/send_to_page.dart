import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class SendToPage extends StatefulWidget {
  const SendToPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SendToPage());
  }

  @override
  State<SendToPage> createState() => _SendToPageState();
}

class _SendToPageState extends State<SendToPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      scrollView: false,
      titleLeading: const BackLeadingButton(),
      titleTrailing: const AccountSwitcherButton(),
      body: BackgroundCard(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.spaceSmall),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  l10n.sendTo,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: Sizes.spaceXLarge,
                ),
                AccountSelectBoxView(caption: l10n.from,),
              ],
            ),
          ),
        ),
      ),
      navigation: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.spaceSmall),
          child: MyElevatedButton(
            borderRadius: Sizes.normalRadius,
            text: l10n.next,
            // onPressed: !state.isMnemonicOrKeyValid
            //     ? null
            //     : () async {
            //   await context
            //       .read<ImportWalletCubit>()
            //       .saveMnemonicOrKey(
            //     mnemonicOrKey: mnemonicController.text,
            //     accountName: widget.accountName,
            //     isFromOnboarding: widget.isFromOnboarding,
            //   );
            // },
          ),
        ),
      ),
    );
  }
}
