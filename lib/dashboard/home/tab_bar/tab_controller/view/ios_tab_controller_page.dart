import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IosTabControllerPage extends StatelessWidget {
  const IosTabControllerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TabControllerCubit(),
      child: const IosTabControllerView(),
    );
  }
}

class IosTabControllerView extends StatefulWidget {
  const IosTabControllerView({Key? key}) : super(key: key);

  @override
  State<IosTabControllerView> createState() => _IosTabControllerViewState();
}

class _IosTabControllerViewState extends State<IosTabControllerView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_onTabChanged);
    super.initState();
  }

  void _onTabChanged() {
    context.read<TabControllerCubit>().setIndex(_tabController.index);
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
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            TabBar(
              controller: _tabController,
              padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
              indicatorPadding: EdgeInsets.zero,
              labelPadding:
                  const EdgeInsets.symmetric(horizontal: Sizes.spaceXSmall),
              indicatorWeight: 0.0001,
              indicatorColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                MyTab(
                  text: l10n.cards,
                  icon: state == 0 ? IconStrings.cards : IconStrings.cardsBlur,
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
                    context.read<TabControllerCubit>().setIndex(0);
                  },
                ),
                MyTab(
                  text: l10n.tokens,
                  icon:
                      state == 1 ? IconStrings.health : IconStrings.healthBlur,
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
                    context.read<TabControllerCubit>().setIndex(1);
                  },
                ),
              ],
            ),
            const SizedBox(height: Sizes.spaceSmall),
            Expanded(
              child: BackgroundCard(
                padding: const EdgeInsets.all(Sizes.spaceSmall),
                margin:
                    const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
                //height: double.infinity,
                child: TabBarView(
                  controller: _tabController,
                  physics: context.read<HomeCubit>().state.homeStatus ==
                          HomeStatus.hasNoWallet
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  children: const [
                    CredentialsListPage(),
                    TokenPage(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
