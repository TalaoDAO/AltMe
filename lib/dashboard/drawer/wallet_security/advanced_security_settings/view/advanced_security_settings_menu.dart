import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdvancedSecuritySettingsMenu extends StatelessWidget {
  const AdvancedSecuritySettingsMenu({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const AdvancedSecuritySettingsMenu(),
      settings: const RouteSettings(name: '/AdvancedSecuritySettingsMenu'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AdvancedSecuritySettingsView();
  }
}

class AdvancedSecuritySettingsView extends StatelessWidget {
  const AdvancedSecuritySettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Drawer(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const BackLeadingButton(
                      padding: EdgeInsets.zero,
                    ),
                    WalletLogo(
                      height: 90,
                      width: MediaQuery.of(context).size.shortestSide * 0.5,
                      showPoweredBy: true,
                    ),
                    const SizedBox(height: Sizes.spaceSmall),
                    DrawerItem2(
                      title: l10n.verifyIssuerWebsiteIdentity,
                      subtitle: l10n.verifyIssuerWebsiteIdentitySubtitle,
                      trailing: SizedBox(
                        height: 25,
                        child: Switch(
                          onChanged: (value) async {
                            await context
                                .read<ProfileCubit>()
                                .updateProfileSetting(
                                  verifySecurityIssuerWebsiteIdentity: value,
                                );
                          },
                          value: state
                              .model
                              .profileSetting
                              .walletSecurityOptions
                              .verifySecurityIssuerWebsiteIdentity,
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    DrawerItem2(
                      title: l10n.confirmVerifierAccess,
                      subtitle: l10n.confirmVerifierAccessSubtitle,
                      trailing: SizedBox(
                        height: 25,
                        child: Switch(
                          onChanged: (value) async {
                            await context
                                .read<ProfileCubit>()
                                .updateProfileSetting(
                                  confirmSecurityVerifierAccess: value,
                                );
                          },
                          value: state
                              .model
                              .profileSetting
                              .walletSecurityOptions
                              .confirmSecurityVerifierAccess,
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    DrawerItem2(
                      title: l10n.secureAuthenticationWithPINCode,
                      subtitle: l10n.secureAuthenticationWithPINCodeSubtitle,
                      trailing: SizedBox(
                        height: 25,
                        child: Switch(
                          onChanged: (value) async {
                            await context
                                .read<ProfileCubit>()
                                .updateProfileSetting(
                                  secureSecurityAuthenticationWithPinCode:
                                      value,
                                );
                          },
                          value: state
                              .model
                              .profileSetting
                              .walletSecurityOptions
                              .secureSecurityAuthenticationWithPinCode,
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
