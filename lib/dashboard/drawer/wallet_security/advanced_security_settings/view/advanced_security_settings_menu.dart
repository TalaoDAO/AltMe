import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
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
          backgroundColor: Theme.of(context).colorScheme.drawerBackground,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    BackLeadingButton(
                      padding: EdgeInsets.zero,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    const Center(
                      child: AltMeLogo(size: 90),
                    ),
                    const SizedBox(
                      height: Sizes.spaceSmall,
                    ),
                    DrawerItem2(
                      title: l10n.verifyIssuerWebsiteIdentity,
                      subtitle: l10n.verifyIssuerWebsiteIdentitySubtitle,
                      trailing: SizedBox(
                        height: 25,
                        child: Switch(
                          onChanged: (value) async {
                            await context
                                .read<ProfileCubit>()
                                .setUserConsentForIssuerAccess(enabled: value);
                          },
                          value: state.model.userConsentForIssuerAccess,
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
                                .setUserConsentForVerifierAccess(
                                  enabled: value,
                                );
                          },
                          value: state.model.userConsentForVerifierAccess,
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
                                .setUserPINCodeForAuthentication(
                                  enabled: value,
                                );
                          },
                          value: state.model.userPINCodeForAuthentication,
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
