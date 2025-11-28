import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/splash/splash.dart';
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
    return StarterView(profileCubit: context.read<ProfileCubit>());
  }
}

class StarterView extends StatelessWidget {
  const StarterView({super.key, required this.profileCubit});

  final ProfileCubit profileCubit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surface,
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
                          width: MediaQuery.of(context).size.shortestSide * 0.6,
                          height: MediaQuery.of(context).size.longestSide * 0.2,
                        ),
                        const Spacer(flex: 3),
                        TitleText(profileModel: state.model),
                        const Spacer(flex: 1),
                        SubTitle(profileModel: state.model),
                        const Spacer(flex: 4),
                        MyOutlinedButton(
                          text: l10n.restoreWallet,
                          onPressed: () async {
                            await profileCubit.setProfileSetting(
                              profileSetting: ProfileSetting.initial(),
                              profileType: ProfileType.diipv3,
                              walletType: WalletType.personal,
                            );
                            await Navigator.of(context).push<void>(
                              ProtectWalletPage.route(
                                routeType: WalletRouteType.import,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        MyElevatedButton(
                          text: l10n.createWallet,
                          verticalSpacing: 15,
                          onPressed: () async {
                            await profileCubit.setProfileSetting(
                              profileSetting: ProfileSetting.initial(),
                              profileType: ProfileType.diipv3,
                              walletType: WalletType.personal,
                            );

                            await Navigator.of(context).push<void>(
                              ProtectWalletPage.route(
                                routeType: WalletRouteType.create,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        const AppVersionDrawer(isShortForm: true),
                        const SizedBox(height: 10),
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
