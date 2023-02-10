import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/splash/cubit/splash_cubit.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static Route<dynamic> route() => MaterialPageRoute<void>(
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
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration.zero, () {
        /// If there is a deepLink we give do as if it coming from QRCode
        context.read<QRCodeScanCubit>().deepLink();
        context.read<BeaconCubit>().startBeacon();

        if (context.read<SplashCubit>().state.isNewVersion) {
          WhatIsNewDialog.show(context);
        }
      });
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

  Future<void> _onStartPassBaseVerification() async {
    final pinCode = await getSecureStorage.get(SecureStorageKeys.pinCode);
    if (pinCode?.isEmpty ?? true) {
      context
          .read<HomeCubit>()
          .startPassbaseVerification(context.read<WalletCubit>());
    } else {
      await Navigator.of(context).push<void>(
        PinCodePage.route(
          isValidCallback: () => context
              .read<HomeCubit>()
              .startPassbaseVerification(context.read<WalletCubit>()),
          restrictToBack: false,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeCubit, HomeState>(
          listener: (context, homeState) {
            if (homeState.passBaseStatus == PassBaseStatus.declined) {
              showDialog<void>(
                context: context,
                builder: (_) => DefaultDialog(
                  title: l10n.verificationDeclinedTitle,
                  description: l10n.verificationDeclinedDescription,
                  buttonLabel: l10n.restartVerification.toUpperCase(),
                  onButtonClick: _onStartPassBaseVerification,
                ),
              );
            }

            if (homeState.passBaseStatus == PassBaseStatus.pending) {
              showDialog<void>(
                context: context,
                builder: (_) => DefaultDialog(
                  title: l10n.verificationPendingTitle,
                  description: l10n.verificationPendingDescription,
                ),
              );
            }

            if (homeState.passBaseStatus == PassBaseStatus.undone) {
              showDialog<void>(
                context: context,
                builder: (_) => KycDialog(
                  startVerificationPressed: _onStartPassBaseVerification,
                ),
              );
            }

            if (homeState.passBaseStatus == PassBaseStatus.complete) {
              showDialog<void>(
                context: context,
                builder: (_) => const FinishKycDialog(),
              );
              context.read<HomeCubit>().getPassBaseStatusBackground();
            }

            if (homeState.passBaseStatus == PassBaseStatus.verified) {
              // LocalNotification().showNotification(
              //   title: l10n.verifiedNotificationTitle,
              //   message: l10n.verifiedNotificationDescription,
              //   link: homeState.link,
              // );

              showDialog<void>(
                context: context,
                builder: (_) => DefaultDialog(
                  title: l10n.verifiedTitle,
                  description: l10n.verifiedDescription,
                  buttonLabel: l10n.verfiedButton.toUpperCase(),
                  onButtonClick: () => context.read<HomeCubit>().launchUrl(),
                ),
              );
            }
          },
        ),
        BlocListener<DashboardCubit, DashboardState>(
          listener: (_, state) {
            if (state.selectedIndex != pageController.page?.toInt()) {
              pageController.jumpToPage(state.selectedIndex);
            }
          },
        )
      ],
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
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
                  ? l10n.myWallet
                  : state.selectedIndex == 1
                      ? l10n.discover
                      : state.selectedIndex == 2
                          ? Parameters.hasCryptoCallToAction
                              ? l10n.buy
                              : l10n.search
                          : '',
              scaffoldKey: scaffoldKey,
              padding: EdgeInsets.zero,
              drawer: const DrawerPage(),
              titleLeading: HomeTitleLeading(
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
              ),
              titleTrailing: Parameters.hasCryptoCallToAction
                  ? const CryptoAccountSwitcherButton()
                  : const SizedBox.shrink(),
              body: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onHorizontalDragEnd: (drag) {
                            if (drag.primaryVelocity! < 0) {
                              if (context.read<HomeCubit>().state.homeStatus ==
                                  HomeStatus.hasNoWallet) {
                                showDialog<void>(
                                  context: context,
                                  builder: (_) => const WalletDialog(),
                                );
                                return;
                              }
                              if (state.selectedIndex != 3) {
                                pageController.nextPage(
                                  duration: pageTurnDuration,
                                  curve: pageTurnCurve,
                                );
                              }
                            } else if (drag.primaryVelocity! > 0) {
                              if (context.read<HomeCubit>().state.homeStatus ==
                                  HomeStatus.hasNoWallet) {
                                showDialog<void>(
                                  context: context,
                                  builder: (_) => const WalletDialog(),
                                );
                                return;
                              }
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
                            children: const [
                              HomePage(),
                              DiscoverPage(),
                              if (Parameters.hasCryptoCallToAction)
                                WertPage()
                              else
                                SearchPage(),
                              LiveChatPage(hideAppBar: true),
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
                            const SizedBox(width: 75 * 0.6),
                            if (Parameters.hasCryptoCallToAction)
                              BottomBarItem(
                                icon: IconStrings.cashInHand,
                                text: l10n.buy,
                                onTap: () => bottomTapped(2),
                                isSelected: state.selectedIndex == 2,
                              )
                            else
                              BottomBarItem(
                                icon: IconStrings.searchNormal,
                                text: l10n.search,
                                onTap: () => bottomTapped(2),
                                isSelected: state.selectedIndex == 2,
                              ),
                            BottomBarItem(
                              icon: IconStrings.messaging,
                              text: l10n.help,
                              onTap: () => bottomTapped(3),
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
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: QRIcon(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
