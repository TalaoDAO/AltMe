import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class StarterPage extends StatelessWidget {
  const StarterPage({super.key});

  static Route<dynamic> route() {
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
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Spacer(flex: 2),
                  const TitleText(),
                  const Spacer(flex: 1),
                  const SubTitle(),
                  const Spacer(flex: 3),
                  const SplashImage(),
                  const Spacer(flex: 2),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        ProtectWalletPage.route(
                          isFromOnboarding: true,
                          routeType: WalletRouteType.import,
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
                      Navigator.of(context).push(
                        ProtectWalletPage.route(
                          isFromOnboarding: true,
                          routeType: WalletRouteType.create,
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
