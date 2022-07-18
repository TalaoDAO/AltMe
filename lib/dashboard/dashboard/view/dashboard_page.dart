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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      /// If there is a deepLink we give do as if it coming from QRCode
      context.read<QRCodeScanCubit>().deepLink();
    });
    super.initState();
  }

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
          onWillPop: () async {
            if (scaffoldKey.currentState!.isDrawerOpen) {
              Navigator.of(context).pop();
            }
            return false;
          },
          child: BasePage(
            scrollView: false,
            title: state.selectedIndex == 0
                ? ''
                : state.selectedIndex == 1
                    ? l10n.discover
                    : state.selectedIndex == 2
                        ? l10n.search
                        : '',
            scaffoldKey: scaffoldKey,
            padding: EdgeInsets.zero,
            drawer: const DrawerPage(),
            titleLeading: state.selectedIndex == 0
                ? HomeTitleLeading(
                    onPressed: () {
                      if (context.read<HomeCubit>().state.homeStatus ==
                          HomeStatus.hasNoWallet) {
                        showDialog<void>(
                          context: context,
                          builder: (_) => const WalletDialog(),
                        );
                        return;
                      }
                      scaffoldKey.currentState!.openDrawer();
                    },
                  )
                : null,
            titleTrailing:
                state.selectedIndex == 0 ? const HomeTitleTrailing() : null,
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onHorizontalDragEnd: (drag) {
                          if (context.read<HomeCubit>().state.homeStatus ==
                              HomeStatus.hasNoWallet) {
                            showDialog<void>(
                              context: context,
                              builder: (_) => const WalletDialog(),
                            );
                            return;
                          }

                          if (drag.primaryVelocity! < 0) {
                            if (state.selectedIndex != 2) {
                              pageController.nextPage(
                                duration: pageTurnDuration,
                                curve: pageTurnCurve,
                              );
                            } else {
                              scaffoldKey.currentState!.openDrawer();
                            }
                          } else if (drag.primaryVelocity! > 0) {
                            if (state.selectedIndex != 0) {
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
                            onTap: () {
                              if (context.read<HomeCubit>().state.homeStatus ==
                                  HomeStatus.hasNoWallet) {
                                showDialog<void>(
                                  context: context,
                                  builder: (_) => const WalletDialog(),
                                );
                                return;
                              }
                              scaffoldKey.currentState!.openDrawer();
                            },
                            isSelected: state.selectedIndex == 3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 1),
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
