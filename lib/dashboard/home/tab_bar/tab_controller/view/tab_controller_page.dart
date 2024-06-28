import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabControllerPage extends StatelessWidget {
  const TabControllerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabControllerView();
  }
}

class TabControllerView extends StatefulWidget {
  const TabControllerView({super.key});

  @override
  State<TabControllerView> createState() => _TabControllerViewState();
}

class _TabControllerViewState extends State<TabControllerView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<HomeTabbarCubit, int>(
      builder: (context, state) {
        _tabController.index = state;
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Sizes.spaceSmall,
                Sizes.spaceSmall,
                Sizes.spaceSmall,
                0,
              ),
              child: TabBar(
                dividerColor: Colors.transparent,
                controller: _tabController,
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.space2XSmall,
                ),
                indicatorPadding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: Sizes.space2XSmall,
                ),
                indicatorWeight: 0.0000001,
                indicator: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.zero,
                  border: Border.all(
                    color: Colors.transparent,
                    width: 0,
                  ),
                ),
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  MyTab(
                    text: l10n.cards,
                    icon:
                        state == 0 ? IconStrings.cards : IconStrings.cardsBlur,
                    isSelected: state == 0,
                    onPressed: () {
                      if (context.read<HomeCubit>().state.homeStatus ==
                          HomeStatus.hasNoWallet) {
                        showDialog<void>(
                          context: context,
                          builder: (_) => const WalletDialog(),
                        );
                        return;
                      }
                      _tabController.animateTo(0);
                      context.read<HomeTabbarCubit>().setIndex(0);
                    },
                  ),
                  MyTab(
                    text: l10n.nfts,
                    icon:
                        state == 1 ? IconStrings.ghost : IconStrings.ghostBlur,
                    isSelected: state == 1,
                    onPressed: () {
                      if (context.read<HomeCubit>().state.homeStatus ==
                          HomeStatus.hasNoWallet) {
                        showDialog<void>(
                          context: context,
                          builder: (_) => const WalletDialog(),
                        );
                        return;
                      }
                      _tabController.animateTo(1);
                      context.read<HomeTabbarCubit>().setIndex(1);
                    },
                  ),
                  MyTab(
                    text: l10n.coins,
                    icon: state == 2
                        ? IconStrings.health
                        : IconStrings.healthBlur,
                    isSelected: state == 2,
                    onPressed: () {
                      if (context.read<HomeCubit>().state.homeStatus ==
                          HomeStatus.hasNoWallet) {
                        showDialog<void>(
                          context: context,
                          builder: (_) => const WalletDialog(),
                        );
                        return;
                      }
                      _tabController.animateTo(2);
                      context.read<HomeTabbarCubit>().setIndex(2);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: Sizes.spaceSmall),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: BlocBuilder<CredentialsCubit, CredentialsState>(
                  builder: (__, _) {
                    return BlocBuilder<WalletCubit, WalletState>(
                      builder: (context, walletState) {
                        return TabBarView(
                          controller: _tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: const [
                            HomeCredentialsListPage(),
                            NftPage(),
                            TokensPage(),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
