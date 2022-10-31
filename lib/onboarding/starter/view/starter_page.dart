import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class StarterPage extends StatelessWidget {
  const StarterPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/starterPage'),
      builder: (_) => const StarterPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.darkGradientStartColor,
                Theme.of(context).colorScheme.darkGradientEndColor,
              ],
              end: Alignment.topCenter,
              begin: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),
              const Padding(
                padding: EdgeInsets.all(Sizes.spaceLarge),
                child: TitleText(),
              ),
              const SubTitle(),
              const Spacer(
                flex: 2,
              ),
              const SplashImage(),
              const Spacer(
                flex: 2,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push<void>(
                    EnterNewPinCodePage.route(
                      isValidCallback: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push<void>(
                          ActiviateBiometricsPage.route(),
                        );
                      },
                      restrictToBack: false,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.spaceLarge),
                  child: GradientButtonText(
                    text: l10n.import_wallet,
                    onPressed: () {},
                    fontSize: 18,
                    upperCase: true,
                  ),
                ),
              ),
              MyGradientButton(
                text: l10n.create_wallet,
                onPressed: () {
                  Navigator.of(context).push<void>(
                    EnterNewPinCodePage.route(
                      isValidCallback: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushAndRemoveUntil<void>(
                          ActiviateBiometricsPage.route(),
                          (Route<dynamic> route) => route.isFirst,
                        );
                      },
                      restrictToBack: false,
                    ),
                  );
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
