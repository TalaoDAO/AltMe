import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelpCenterMenu extends StatelessWidget {
  const HelpCenterMenu({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const HelpCenterMenu(),
      settings: const RouteSettings(name: '/HelpCenterMenu'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const HelpCenterView();
  }
}

class HelpCenterView extends StatelessWidget {
  const HelpCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final helpCenterOptions = context
        .read<ProfileCubit>()
        .state
        .model
        .profileSetting
        .helpCenterOptions;

    var email = AltMeStrings.appSupportMail;

    /// set the email to custom email
    if (helpCenterOptions.customEmailSupport &&
        helpCenterOptions.customEmail != null) {
      email = helpCenterOptions.customEmail!;
    }

    var customChatSupportName = l10n.support;

    /// set the custom chat support
    if (helpCenterOptions.customChatSupport &&
        helpCenterOptions.customChatSupportName != null) {
      customChatSupportName = helpCenterOptions.customChatSupportName!;
    }

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
          if (helpCenterOptions.displayChatSupport) ...[
            DrawerItem(
              title: '${l10n.chatWith} $customChatSupportName',
              onTap: () {
                Navigator.of(context).push<void>(
                  AltmeSupportChatPage.route(
                    appBarTitle: '${l10n.chatWith} $customChatSupportName',
                  ),
                );
              },
            ),
          ],
          if (helpCenterOptions.displayEmailSupport) ...[
            DrawerItem(
              title: l10n.sendAnEmail,
              onTap: () {
                Navigator.of(context).push<void>(
                  ContactUsPage.route(
                    email: email,
                  ),
                );
              },
            ),
          ],
          DrawerItem(
            title: l10n.faqs,
            onTap: () {
              Navigator.of(context).push<void>(FAQsPage.route());
            },
          ),
          DrawerItem(
            onTap: () {
              LaunchUrl.launch(
                'https://${AltMeStrings.appContactWebsiteName}',
              );
            },
            title: l10n.officialWebsite,
          ),
        ],
      ),
    );
  }
}
