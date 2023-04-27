import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/kyc_verification/cubit/kyc_verification_cubit.dart';
import 'package:altme/kyc_verification/kyc_verification.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/splash/cubit/splash_cubit.dart';
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

        final splashCubit = context.read<SplashCubit>();
        if (splashCubit.state.isNewVersion) {
          WhatIsNewDialog.show(context);
          splashCubit.disableWhatsNewPopUp();
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

  String _getTitle(int selectedIndex, AppLocalizations l10n) {
    switch (selectedIndex) {
      case 0:
        return l10n.myWallet;
      case 1:
        return l10n.discover;
      case 2:
        return Parameters.hasCryptoCallToAction ? l10n.buy : l10n.search;
      case 3:
        return l10n.chat;
      default:
        return '';
    }
  }

  void _startKycVerification() {
    Navigator.of(context).push<void>(
      PinCodePage.route(
        isValidCallback: () {
          context.read<KycVerificationCubit>().startKycVerifcation();
        },
        restrictToBack: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MultiBlocListener(
      listeners: [
        BlocListener<MnemonicNeedVerificationCubit, bool>(
          listener: (context, needsVerification) {
            if (needsVerification) {
              showDialog<void>(
                context: context,
                builder: (_) => DefaultDialog(
                  title: l10n.warningDialogTitle,
                  description: l10n.needMnemonicVerificatinoDescription,
                  buttonLabel: l10n.verifyNow,
                  onButtonClick: () {
                    Navigator.of(context).push<void>(
                      PinCodePage.route(
                        isValidCallback: () => Navigator.of(context)
                            .push<void>(RecoveryKeyPage.route()),
                        restrictToBack: false,
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
        BlocListener<KycVerificationCubit, KycVerificationState>(
          listener: (context, homeState) {
            if (homeState.status == KycVerificationStatus.rejected) {
              showDialog<void>(
                context: context,
                builder: (_) => DefaultDialog(
                  title: l10n.verificationDeclinedTitle,
                  description: l10n.verificationDeclinedDescription,
                  buttonLabel: l10n.restartVerification.toUpperCase(),
                  onButtonClick: _startKycVerification,
                ),
              );
            }

            if (homeState.status == KycVerificationStatus.pending) {
              showDialog<void>(
                context: context,
                builder: (_) => DefaultDialog(
                  title: l10n.verificationPendingTitle,
                  description: l10n.verificationPendingDescription,
                ),
              );
            }

            if (homeState.status == KycVerificationStatus.unverified) {
              showDialog<void>(
                context: context,
                builder: (_) => KycDialog(
                  startVerificationPressed: _startKycVerification,
                ),
              );
            }

            if (homeState.status == KycVerificationStatus.approved) {
              showDialog<void>(
                context: context,
                builder: (_) => DefaultDialog(
                  title: l10n.verifiedTitle,
                  description: l10n.verifiedDescription,
                  buttonLabel: l10n.verfiedButton.toUpperCase(),
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
          if (state.selectedIndex == 3) {
            context.read<AltmeChatSupportCubit>().setMessagesAsRead();
          }
          return WillPopScope(
            onWillPop: () async {
              if (scaffoldKey.currentState!.isDrawerOpen) {
                Navigator.of(context).pop();
              }
              return false;
            },
            child: BasePage(
              scrollView: false,
              title: _getTitle(state.selectedIndex, l10n),
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
                        child: PageView(
                          controller: pageController,
                          onPageChanged:
                              context.read<DashboardCubit>().onPageChanged,
                          physics: const NeverScrollableScrollPhysics(),
                          children: const [
                            HomePage(),
                            if (Parameters.hasCryptoCallToAction)
                              DiscoverTabPage()
                            else
                              DiscoverPage(),
                            if (Parameters.hasCryptoCallToAction)
                              WertPage()
                            else
                              SearchPage(),
                            AltmeSupportChatPage(),
                          ],
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
                            StreamBuilder(
                              stream: context
                                  .read<AltmeChatSupportCubit>()
                                  .unreadMessageCountStream,
                              builder: (_, snapShot) {
                                return BottomBarItem(
                                  icon: IconStrings.messaging,
                                  text: l10n.chat,
                                  badgeCount: snapShot.data ?? 0,
                                  onTap: () => bottomTapped(3),
                                  isSelected: state.selectedIndex == 3,
                                );
                              },
                            )
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
      ),
    );
  }
}
