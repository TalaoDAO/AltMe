import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/drawer/drawer.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
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
                if (helpCenterOptions.displayChatSupport) ...[
                  const SizedBox(height: Sizes.spaceSmall),
                  DrawerItem(
                    title: '${l10n.chatWith} $customChatSupportName',
                    onTap: () {
                      Navigator.of(context).push<void>(
                        AltmeSupportChatPage.route(
                          appBarTitle:
                              '${l10n.chatWith} $customChatSupportName',
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
          ),
        ),
      ),
    );
  }
}
