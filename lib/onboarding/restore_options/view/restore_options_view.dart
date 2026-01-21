import 'package:altme/app/app.dart';
import 'package:altme/import_wallet/import_wallet.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RestoreOptionsPage extends StatelessWidget {
  const RestoreOptionsPage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const RestoreOptionsPage(),
      settings: const RouteSettings(name: '/RestoreOptionsPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RestoreOptionsCubit(),
      child: const RestoreOptionsView(),
    );
  }
}

class RestoreOptionsView extends StatelessWidget {
  const RestoreOptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<RestoreOptionsCubit, RestoreType>(
      builder: (context, state) {
        return BasePage(
          scrollView: false,
          useSafeArea: true,
          padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceXSmall),
          titleLeading: const BackLeadingButton(),
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: l10n.restore,
          titleAlignment: Alignment.topCenter,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: Sizes.spaceNormal),
              RestoreOptionWidget(
                title: l10n.restoreACryptoWallet,
                isSelected: state == RestoreType.cryptoWallet,
                onTap: () => context.read<RestoreOptionsCubit>().updateSwitch(
                  RestoreType.cryptoWallet,
                ),
              ),
              RestoreOptionWidget(
                title: l10n.restoreAnAppBackup(Parameters.appName),
                isSelected: state == RestoreType.appBackup,
                onTap: () => context.read<RestoreOptionsCubit>().updateSwitch(
                  RestoreType.appBackup,
                ),
              ),
            ],
          ),
          navigation: Padding(
            padding: const EdgeInsets.all(Sizes.spaceSmall),
            child: MyElevatedButton(
              text: l10n.continueString,
              onPressed: () {
                Navigator.of(
                  context,
                ).push<void>(ImportWalletPage.route(restoreType: state));
              },
            ),
          ),
        );
      },
    );
  }
}
