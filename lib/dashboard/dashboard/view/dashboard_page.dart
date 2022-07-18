import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => const DashboardPage(),
        settings: const RouteSettings(name: '/dashboardPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit(),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Duration pageTurnDuration = const Duration(milliseconds: 500);
  Curve pageTurnCurve = Curves.ease;

  void bottomTapped(int index) {
    if (context.read<HomeCubit>().state.homeStatus == HomeStatus.hasNoWallet) {
      showDialog<void>(
        context: context,
        builder: (_) => const WalletDialog(),
      );
      return;
    }
    context.read<DashboardCubit>().onPageChanged(index);
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final l10n = context.l10n;
        return WillPopScope(
          onWillPop: () async => false,
          child: BasePage(
            scrollView: false,
            padding: EdgeInsets.zero,
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onHorizontalDragEnd: (drag) {
                          if (drag.primaryVelocity! < 0) {
                            if (state.selectedIndex != 3) {
                              if (context.read<HomeCubit>().state.homeStatus ==
                                  HomeStatus.hasNoWallet) {
                                showDialog<void>(
                                  context: context,
                                  builder: (_) => const WalletDialog(),
                                );
                                return;
                              }

                              pageController.nextPage(
                                duration: pageTurnDuration,
                                curve: pageTurnCurve,
                              );
                            }
                          } else if (drag.primaryVelocity! > 0) {
                            if (state.selectedIndex != 0) {
                              if (context.read<HomeCubit>().state.homeStatus ==
                                  HomeStatus.hasNoWallet) {
                                showDialog<void>(
                                  context: context,
                                  builder: (_) => const WalletDialog(),
                                );
                                return;
                              }
                              pageController.previousPage(
                                duration: pageTurnDuration,
                                curve: pageTurnCurve,
                              );
                            }
                          }
                        },
                        child: PageView(
                          controller: pageController,
                          onPageChanged:
                              context.read<DashboardCubit>().onPageChanged,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            const HomePage(),
                            const DiscoverPage(),
                            const SearchPage(),
                            Container(),
                          ],
                        ),
                      ),
                    ),
                    BottomBarDecoration(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BottomBarItem(
                            icon: IconStrings.home,
                            text: l10n.home,
                            onTap: () => bottomTapped(0),
                            isSelected: state.selectedIndex == 0,
                          ),
                          BottomBarItem(
                            icon: IconStrings.discover,
                            text: l10n.discover,
                            onTap: () => bottomTapped(1),
                            isSelected: state.selectedIndex == 1,
                          ),
                          const SizedBox.shrink(),
                          const SizedBox.shrink(),
                          BottomBarItem(
                            icon: IconStrings.searchNormal,
                            text: l10n.search,
                            onTap: () => bottomTapped(2),
                            isSelected: state.selectedIndex == 2,
                          ),
                          BottomBarItem(
                            icon: IconStrings.settings,
                            text: l10n.settings,
                            onTap: () {},
                            isSelected: state.selectedIndex == 3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: QRIcon(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
