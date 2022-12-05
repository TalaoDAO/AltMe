import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class ResetWalletMenu extends StatelessWidget {
  const ResetWalletMenu({super.key});

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ResetWalletMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const ResetWalletView();
  }
}

class ResetWalletView extends StatelessWidget {
  const ResetWalletView({super.key});

  @override
  Widget build(BuildContext context) {
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
