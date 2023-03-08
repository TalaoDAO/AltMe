import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TokenRewardDialog extends StatelessWidget {
  const TokenRewardDialog({
    super.key,
    required this.tokenReward,
  });

  final TokenReward tokenReward;

  static void show({
    required BuildContext context,
    required TokenReward tokenReward,
  }) {
    showDialog<void>(
      context: context,
      builder: (_) => TokenRewardDialog(
        tokenReward: tokenReward,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.popupBackground,
      surfaceTintColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Sizes.spaceNormal,
        vertical: Sizes.spaceSmall,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DialogCloseButton(),
            const SizedBox(height: Sizes.spaceSmall),
            Text(
              l10n.rewardDialogTitle,
              style: Theme.of(context).textTheme.defaultDialogTitle.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceSmall),
            Text.rich(
              TextSpan(
                text: l10n.rewardDialogDescPart1,
                style: Theme.of(context).textTheme.defaultDialogBody,
                children: [
                  TextSpan(
                    text:
                        ''' ${tokenReward.amount.toString().formatNumber()} ${tokenReward.symbol} ''',
                    style:
                        Theme.of(context).textTheme.defaultDialogBody.copyWith(
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                  ),
                  TextSpan(
                    text: '${l10n.rewardDialogDescPart2} : ',
                  ),
                  TextSpan(
                    text:
                        '''${tokenReward.account.substring(0, 6)}...${tokenReward.account.substring(tokenReward.account.length - 6)}''',
                    style:
                        Theme.of(context).textTheme.defaultDialogBody.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        LaunchUrl.launch(
                          'https://tzkt.io/${tokenReward.txId}/${tokenReward.counter}',
                        );
                      },
                  ),
                  TextSpan(
                    text: '\n\n${l10n.origin}: ${tokenReward.origin}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: Sizes.spaceSmall),
            MyElevatedButton(
              text: l10n.gotIt.toUpperCase(),
              verticalSpacing: 18,
              fontSize: 18,
              borderRadius: 20,
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
