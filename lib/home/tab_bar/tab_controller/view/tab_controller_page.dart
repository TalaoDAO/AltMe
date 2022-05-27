import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/home/tab_bar/tab_controller/cubit/tab_controller_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
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

class TabControllerView extends StatelessWidget {
  const TabControllerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<TabControllerCubit, int>(
      builder: (context, state) {
        return DefaultTabController(
          length: 3,
          child: Column(
            children: [
              SizedBox(
                height: 80,
                child: TabBar(
                  onTap: context.read<TabControllerCubit>().setIndex,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: const [0.3, 1.0],
                    ),
                  ),
                  labelColor: Theme.of(context).colorScheme.label,
                  unselectedLabelColor:
                      Theme.of(context).colorScheme.unSelectedLabel,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  tabs: [
                    MyTab(
                      text: l10n.cards,
                      icon: state == 0
                          ? IconStrings.userSquare
                          : IconStrings.userSquareBlur,
                    ),
                    MyTab(
                      text: l10n.nfts,
                      icon: state == 1
                          ? IconStrings.ghost
                          : IconStrings.ghostBlur,
                    ),
                    MyTab(
                      text: l10n.tokens,
                      icon: state == 2
                          ? IconStrings.health
                          : IconStrings.healthBlur,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: BackgroundCard(
                    child: TabBarView(
                      children: [
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
