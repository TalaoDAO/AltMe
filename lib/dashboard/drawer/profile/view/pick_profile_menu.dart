import 'package:altme/app/app.dart';
import 'package:altme/dashboard/drawer/profile/widget/profile_selector_widget.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class PickProfileMenu extends StatelessWidget {
  const PickProfileMenu({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/PickProfileMenu'),
      builder: (_) => const PickProfileMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const PickProfileMenuView();
  }
}

class PickProfileMenuView extends StatelessWidget {
  const PickProfileMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.walletProfiles,
      useSafeArea: true,
      scrollView: true,
      titleAlignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
      titleLeading: const BackLeadingButton(),
      body: const ProfileSelectorWidget(),
    );
  }
}
