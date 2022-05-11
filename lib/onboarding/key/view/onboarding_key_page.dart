import 'package:altme/app/shared/widget/base/button.dart';
import 'package:altme/app/shared/widget/base/page.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/gen_phrase/view/onboarding_gen_phrase.dart';
import 'package:altme/onboarding/recovery/view/onboarding_recovery.dart';
import 'package:flutter/material.dart';

class OnBoardingKeyPage extends StatelessWidget {
  const OnBoardingKeyPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => const OnBoardingKeyPage(),
        settings: const RouteSettings(name: '/onBoardingKeyPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: BasePage(
        title: l10n.onBoardingKeyTitle,
        scrollView: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    l10n.keyRecoveryTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    l10n.keyRecoveryText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 20),
                  BaseButton.primary(
                    context: context,
                    onPressed: () {
                      Navigator.of(context)
                          .push<void>(OnBoardingRecoveryPage.route());
                    },
                    child: Text(l10n.onBoardingKeyRecover),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    l10n.keyGenerateTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    l10n.keyGenerateText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 20),
                  BaseButton.primary(
                    context: context,
                    onPressed: () {
                      Navigator.of(context)
                          .push<void>(OnBoardingGenPhrasePage.route());
                    },
                    child: Text(l10n.onBoardingKeyGenerate),
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
