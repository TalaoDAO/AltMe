import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

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

    final profileCubit = context.read<ProfileCubit>();

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
                  const Spacer(flex: 5),
                  const SplashImage(),
                  const Spacer(flex: 3),
                  const TitleText(),
                  const Spacer(flex: 1),
                  const SubTitle(),
                  const Spacer(flex: 4),
                  GradientButtonText(
                    text: l10n.import_wallet,
                    onPressed: () async {
                      await profileCubit.setWalletType(
                        walletType: WalletType.personal,
                      );
                      await Navigator.of(context).push(
                        ProtectWalletPage.route(
                          routeType: WalletRouteType.import,
                        ),
                      );
                    },
                    fontSize: 18,
                    upperCase: true,
                  ),
                  const Spacer(flex: 1),
                  MyGradientButton(
                    text: l10n.create_wallet,
                    onPressed: () async {
                      await profileCubit.setWalletType(
                        walletType: WalletType.personal,
                      );
                      await Navigator.of(context).push(
                        ProtectWalletPage.route(
                          routeType: WalletRouteType.create,
                        ),
                      );
                    },
                  ),
                  const Spacer(flex: 1),
                  MyGradientButton(
                    text: l10n.createAnEnterPriseWallet,
                    onPressed: () async {
                      await profileCubit.setWalletType(
                        walletType: WalletType.enterprise,
                      );
                      await Navigator.of(context).push(
                        EnterpriseLoginPage.route(),
                      );
                    },
                  ),
                  const Spacer(flex: 1),
                  const AppVersionDrawer(isShortForm: true),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
