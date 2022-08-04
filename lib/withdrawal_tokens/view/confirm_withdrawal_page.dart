import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/withdrawal_tokens/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ConfirmWithdrawalPage extends StatefulWidget {
  const ConfirmWithdrawalPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ConfirmWithdrawalPage(),
    );
  }

  @override
  State<ConfirmWithdrawalPage> createState() => _ConfirmWithdrawalPageState();
}

class _ConfirmWithdrawalPageState extends State<ConfirmWithdrawalPage> {
  final TextEditingController withdrawalAddressController =
      TextEditingController();

  final AccountSelectBoxController accountSelectBoxController =
      AccountSelectBoxController();

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                l10n.confirm,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: Sizes.spaceSmall,
              ),
              Text(
                '139.2319 XTZ',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(
                height: Sizes.spaceSmall,
              ),
              Text(
                l10n.amount,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption2,
              ),
              const SizedBox(
                height: Sizes.spaceSmall,
              ),
              AccountSelectBoxView(
                controller: accountSelectBoxController,
                caption: l10n.from,
              ),
              const SizedBox(
                height: Sizes.spaceNormal,
              ),
              WithdrawalAddressInputView(
                withdrawalAddressController: withdrawalAddressController,
                caption: l10n.to,
              ),
              Padding(
                padding: const EdgeInsets.all(Sizes.spaceSmall),
                child: Image.asset(
                  IconStrings.arrowDown,
                  height: Sizes.icon3x,
                ),
              ),
              ConfirmDetailsCard(),
            ],
          ),
        ),
      ),
      navigation: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: Sizes.spaceSmall,
            right: Sizes.spaceSmall,
            bottom: Sizes.spaceSmall,
          ),
          child: MyElevatedButton(
            borderRadius: Sizes.normalRadius,
            text: l10n.confirm,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
