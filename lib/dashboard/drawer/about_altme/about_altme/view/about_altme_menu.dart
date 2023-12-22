import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutAltmeMenu extends StatelessWidget {
  const AboutAltmeMenu({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const AboutAltmeMenu(),
      settings: const RouteSettings(name: '/AboutAltmeMenu'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AboutAltmeView();
  }
}

class AboutAltmeView extends StatelessWidget {
  const AboutAltmeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final profileModel = context.read<ProfileCubit>().state.model;

        final profileSetting = profileModel.profileSetting;
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
                    Center(
                      child: WalletLogo(
                        profileModel: profileModel,
                        height: 90,
                        width: MediaQuery.of(context).size.shortestSide * 0.5,
                      ),
                    ),
                    if (profileModel.profileType.showSponseredBy) ...[
                      const SizedBox(height: 5),
                      const Center(child: PoweredByText()),
                    ],
                    const SizedBox(height: Sizes.spaceSmall),
                    const AppVersionDrawer(),
                    const SizedBox(height: Sizes.spaceLarge),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.spaceXSmall,
                      ),
                      child: Text(
                        l10n.organizationProfile,
                        style: Theme.of(context)
                            .textTheme
                            .drawerItemTitle
                            .copyWith(
                              fontSize: 18,
                            ),
                      ),
                    ),
                    const SizedBox(height: Sizes.spaceXSmall),
                    EnterpriseData(
                      title: l10n.profileName,
                      value: profileSetting.generalOptions.profileName,
                    ),
                    EnterpriseData(
                      title: l10n.companyName,
                      value: profileSetting.generalOptions.companyName,
                    ),
                    EnterpriseData(
                      title: l10n.configFileIdentifier,
                      value: profileSetting.generalOptions.profileId,
                    ),
                    const SizedBox(height: Sizes.spaceSmall),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.spaceXSmall,
                      ),
                      child: Text(
                        l10n.about,
                        style: Theme.of(context)
                            .textTheme
                            .drawerItemTitle
                            .copyWith(
                              fontSize: 18,
                            ),
                      ),
                    ),
                    const SizedBox(height: Sizes.spaceXSmall),
                    FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (_, snapShot) {
                        var appVersion = '...';
                        if (snapShot.connectionState == ConnectionState.done) {
                          appVersion = snapShot.data?.version ?? '0.1.0';
                        }
                        return DrawerItem(
                          title: '${l10n.yourAppVersion} : $appVersion',
                          trailing: const Center(),
                        );
                      },
                    ),
                    DrawerItem(
                      title: l10n.termsOfUse,
                      onTap: () =>
                          Navigator.of(context).push<void>(TermsPage.route()),
                    ),
                    DrawerItem(
                      title: l10n.softwareLicenses,
                      onTap: () => Navigator.of(context)
                          .push<void>(SoftwareLicensePage.route()),
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
