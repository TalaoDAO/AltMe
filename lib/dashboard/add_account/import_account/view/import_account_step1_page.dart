import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_generator/key_generator.dart';

class ImportAccountStep1Page extends StatelessWidget {
  const ImportAccountStep1Page({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/importAccountStep1Page'),
      builder: (_) => const ImportAccountStep1Page(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const ImportAccountStep1View();
  }
}

class ImportAccountStep1View extends StatelessWidget {
  const ImportAccountStep1View({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.importAccount,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      padding: const EdgeInsets.only(
        top: 0,
        left: Sizes.spaceSmall,
        right: Sizes.spaceSmall,
        bottom: Sizes.spaceSmall,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, profileStae) {
          final profileSetting = profileStae.model.profileSetting;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const MStepper(totalStep: 4, step: 1),
              const SizedBox(height: Sizes.spaceNormal),
              Text(
                l10n.importEasilyFrom,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: Sizes.spaceNormal),
              if (BlockchainType.tezos.isSupported(profileSetting)) ...[
                CustomListTileCard(
                  title: l10n.tezosAccount,
                  subTitle: l10n.tezosAccountDescription,
                  imageAssetPath: IconStrings.tezos,
                  onTap: () {
                    Navigator.of(context).push<void>(
                      ImportAccountStep2Page.route(
                          accountType: AccountType.tezos),
                    );
                  },
                ),
                const SizedBox(height: Sizes.spaceNormal),
              ],
              if (BlockchainType.ethereum.isSupported(profileSetting)) ...[
                CustomListTileCard(
                  title: l10n.ethereumAccount,
                  subTitle: l10n.ethereumAccountDescription,
                  imageAssetPath: IconStrings.ethereum,
                  onTap: () {
                    Navigator.of(context).push<void>(
                      ImportAccountStep2Page.route(
                          accountType: AccountType.ethereum),
                    );
                  },
                ),
                const SizedBox(height: Sizes.spaceNormal),
              ],
              if (BlockchainType.fantom.isSupported(profileSetting)) ...[
                CustomListTileCard(
                  title: l10n.fantomAccount,
                  subTitle: l10n.fantomAccountDescription,
                  imageAssetPath: IconStrings.fantom,
                  onTap: () {
                    Navigator.of(context).push<void>(
                      ImportAccountStep2Page.route(
                          accountType: AccountType.fantom),
                    );
                  },
                ),
                const SizedBox(height: Sizes.spaceNormal),
              ],
              if (BlockchainType.polygon.isSupported(profileSetting)) ...[
                CustomListTileCard(
                  title: l10n.polygonAccount,
                  subTitle: l10n.polygonAccountDescription,
                  imageAssetPath: IconStrings.polygon,
                  onTap: () {
                    Navigator.of(context).push<void>(
                      ImportAccountStep2Page.route(
                          accountType: AccountType.polygon),
                    );
                  },
                ),
                const SizedBox(height: Sizes.spaceNormal),
              ],
              if (BlockchainType.binance.isSupported(profileSetting)) ...[
                CustomListTileCard(
                  title: l10n.binanceAccount,
                  subTitle: l10n.binanceAccountDescription,
                  imageAssetPath: IconStrings.binance,
                  onTap: () {
                    Navigator.of(context).push<void>(
                      ImportAccountStep2Page.route(
                          accountType: AccountType.binance),
                    );
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
