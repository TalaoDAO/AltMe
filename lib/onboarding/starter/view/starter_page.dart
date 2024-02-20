import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Spacer(flex: 5),
                        WalletLogo(
                          profileModel: state.model,
                          width: MediaQuery.of(context).size.shortestSide * 0.6,
                          height: MediaQuery.of(context).size.longestSide * 0.2,
                        ),
                        const Spacer(flex: 3),
                        TitleText(profileModel: state.model),
                        const Spacer(flex: 1),
                        SubTitle(profileModel: state.model),
                        const Spacer(flex: 4),
                        MyGradientButton(
                          text: l10n.createPersonalWallet,
                          verticalSpacing: 15,
                          onPressed: () async {
                            await profileCubit.setWalletType(
                              walletType: WalletType.personal,
                            );
                            await profileCubit.setProfileSetting(
                              profileSetting: ProfileSetting.initial(),
                              profileType: ProfileType.defaultOne,
                            );
                            await showDialog<void>(
                              context: context,
                              builder: (_) => const WalletDialog(),
                            );
                          },
                        ),
                        const Spacer(flex: 1),
                        MyOutlinedButton(
                          text: l10n.createAnProfessionalWallet,
                          textColor: Theme.of(context).colorScheme.lightPurple,
                          borderColor:
                              Theme.of(context).colorScheme.lightPurple,
                          backgroundColor: Colors.transparent,
                          onPressed: () async {
                            await profileCubit.setWalletType(
                              walletType: WalletType.enterprise,
                            );
                            await Navigator.of(context).push(
                              EnterpriseInitializationPage.route(),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
