import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/home/tab_bar/tab_controller/cubit/tab_controller_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabControllerPage extends StatelessWidget {
  const TabControllerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TabControllerCubit(),
      child: const TabControllerView(),
    );
  }
}

class TabControllerView extends StatefulWidget {
  const TabControllerView({Key? key}) : super(key: key);

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
    return BlocBuilder<TabControllerCubit, int>(
      builder: (context, state) {
        return DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: MyTab(
                        text: l10n.cards,
                        icon: state == 0
                            ? IconStrings.userSquare
                            : IconStrings.userSquareBlur,
                        isSelected: state == 0,
                        onPressed: () {
                          if (context.read<HomeCubit>().state ==
                              HomeStatus.hasNoWallet) {
                            showDialog<void>(
                              context: context,
                              builder: (_) => const WalletDialog(),
                            );
                            return;
                          }
                          _tabController.animateTo(0);
                          context.read<TabControllerCubit>().setIndex(0);
                        },
                      ),
                    ),
                    Expanded(
                      child: MyTab(
                        text: l10n.nfts,
                        icon: state == 1
                            ? IconStrings.ghost
                            : IconStrings.ghostBlur,
                        isSelected: state == 1,
                        onPressed: () {
                          if (context.read<HomeCubit>().state ==
                              HomeStatus.hasNoWallet) {
                            showDialog<void>(
                              context: context,
                              builder: (_) => const WalletDialog(),
                            );
                            return;
                          }
                          _tabController.animateTo(1);
                          context.read<TabControllerCubit>().setIndex(1);
                        },
                      ),
                    ),
                    Expanded(
                      child: MyTab(
                        text: l10n.tokens,
                        icon: state == 2
                            ? IconStrings.health
                            : IconStrings.healthBlur,
                        isSelected: state == 2,
                        onPressed: () {
                          if (context.read<HomeCubit>().state ==
                              HomeStatus.hasNoWallet) {
                            showDialog<void>(
                              context: context,
                              builder: (_) => const WalletDialog(),
                            );
                            return;
                          }
                          _tabController.animateTo(2);
                          context.read<TabControllerCubit>().setIndex(2);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: BackgroundCard(
                    child: TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        CredentialsListPage(),
                        NftPage(),
                        TokenPage(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
