import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
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
    return BlocBuilder<TabControllerCubit, int>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
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
                    // if (context.read<HomeCubit>().state.homeStatus ==
                    //     HomeStatus.hasNoWallet)
                    //   const DiscoverPage()
                    // else
                    CredentialsListPage(),
                    NftPage(),
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
