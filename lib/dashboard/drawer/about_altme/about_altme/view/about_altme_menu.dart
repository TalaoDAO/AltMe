import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        return BasePage(
          backgroundColor: Theme.of(context).colorScheme.surface,
          useSafeArea: true,
          scrollView: true,
          titleAlignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const BackLeadingButton(
                padding: EdgeInsets.zero,
              ),
              const DrawerLogo(),
              const AppVersionDrawer(),
              if (profileModel.profileType == ProfileType.enterprise) ...[
                const SizedBox(height: Sizes.spaceXSmall),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.spaceXSmall,
                  ),
                  child: Text(
                    profileSetting.generalOptions.companyName,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 18,
                        ),
                  ),
                ),
                const SizedBox(height: Sizes.spaceXSmall),
                DrawerItem(
                  title: '${l10n.profileName} :'
                      ' ${profileSetting.generalOptions.profileName}',
                  trailing: Container(),
                ),
                DrawerItem(
                  title: '${l10n.configFileIdentifier} :'
                      ' ${profileSetting.generalOptions.profileId}',
                  trailing: Container(),
                ),
                const SizedBox(height: Sizes.spaceSmall),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.spaceXSmall,
                  ),
                  child: Text(
                    l10n.about,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 18,
                        ),
                  ),
                ),
              ],
              const SizedBox(height: Sizes.spaceXSmall),
              // FutureBuilder<PackageInfo>(
              //   future: PackageInfo.fromPlatform(),
              //   builder: (_, snapShot) {
              //     var appVersion = '...';
              //     if (snapShot.connectionState == ConnectionState.done) {
              //       appVersion = snapShot.data?.version ?? '0.1.0';
              //     }
              //     return DrawerItem(
              //       title: '${l10n.yourAppVersion} : $appVersion',
              //       trailing: Container(),
              //     );
              //   },
              // ),
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
        );
      },
    );
  }
}
