import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/tab_controller/widgets/compellio_content_tab.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  Future<void> onRefresh() async {
    await context.read<CredentialsCubit>().loadAllCredentials();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final PageController pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );

    return BasePage(
      scrollView: false,
      padding:
          // Parameters.walletHandlesCrypto
          // ? EdgeInsets.zero
          // :
          const EdgeInsets.fromLTRB(
            Sizes.spaceSmall,
            Sizes.spaceSmall,
            Sizes.spaceSmall,
            0,
          ),
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              child: Text(
                'Check your credentials cards',
                maxLines: 3,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w100),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: 130,
                child: CompellioContentTab(
                  text: l10n.cards,
                  icon: IconStrings.cards,
                  isSelected: true,
                  onPressed: () {
                    if (context.read<HomeCubit>().state.homeStatus ==
                        HomeStatus.hasNoWallet) {
                      showDialog<void>(
                        context: context,
                        builder: (_) => const WalletDialog(),
                      );
                      return;
                    }
                    context.read<HomeTabbarCubit>().setIndex(0);
                    context.read<DashboardCubit>().onPageChanged(0);
                    pageController.jumpToPage(0);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              child: Text(
                'See your NFTs',
                maxLines: 3,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w100),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: 130,
                child: CompellioContentTab(
                  text: l10n.nfts,
                  icon: IconStrings.ghost,
                  isSelected: true,
                  onPressed: () {
                    if (context.read<HomeCubit>().state.homeStatus ==
                        HomeStatus.hasNoWallet) {
                      showDialog<void>(
                        context: context,
                        builder: (_) => const WalletDialog(),
                      );
                      return;
                    }
                    context.read<HomeTabbarCubit>().setIndex(1);
                    context.read<DashboardCubit>().onPageChanged(0);
                    pageController.jumpToPage(0);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              child: Text(
                'Get started with your crypto coins',
                maxLines: 3,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w100),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: 130,
                child: CompellioContentTab(
                  text: l10n.coins,
                  icon: IconStrings.health,
                  isSelected: true,
                  onPressed: () {
                    if (context.read<HomeCubit>().state.homeStatus ==
                        HomeStatus.hasNoWallet) {
                      showDialog<void>(
                        context: context,
                        builder: (_) => const WalletDialog(),
                      );
                      return;
                    }
                    context.read<HomeTabbarCubit>().setIndex(2);
                    context.read<DashboardCubit>().onPageChanged(0);
                    pageController.jumpToPage(0);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
