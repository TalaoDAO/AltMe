import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/enterprise/cubit/enterprise_cubit.dart';
import 'package:altme/kyc_verification/kyc_verification.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/matrix_notification/matrix_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static Route<dynamic> route() => MaterialPageRoute<void>(
        builder: (context) => const DashboardPage(),
        settings: const RouteSettings(name: AltMeStrings.dashBoardPage),
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

        // check if enterprise account is suspended or not
        if (context.read<ProfileCubit>().state.model.profileType ==
            ProfileType.enterprise) {
          unawaited(
            context.read<EnterpriseCubit>().getWalletAttestationBitStatus(),
          );
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
        return Parameters.walletHandlesCrypto ? l10n.buy : l10n.search;
      case 3:
        return l10n.chat;
      default:
        return '';
    }
  }

  // Future<void> _startKycVerification() async {
  //   await securityCheck(
  //     context: context,
  //     localAuthApi: LocalAuthApi(),
  //     onSuccess: () {
  //       context.read<KycVerificationCubit>().startKycVerifcation(
  //             vcType: KycVcType.verifiableId,
  //           );
  //     },
  //   );
  // }

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
                  onButtonClick: () async {
                    await securityCheck(
                      context: context,
                      title: l10n.typeYourPINCodeToAuthenticate,
                      localAuthApi: LocalAuthApi(),
                      onSuccess: () => Navigator.of(context)
                          .push<void>(RecoveryKeyPage.route()),
                    );
                  },
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
        ),
        BlocListener<KycVerificationCubit, KycVerificationState>(
          listener: (_, state) {
            if (state.status == KycVerificationStatus.loading) {
              LoadingView().show(context: context);
            } else {
              LoadingView().hide();
            }
          },
        ),
        BlocListener<DeepLinkCubit, String>(
          listener: (_, state) {
            context.read<QRCodeScanCubit>().deepLink();
          },
        ),
      ],
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, dashboardState) {
          if (dashboardState.selectedIndex == 3) {
            context.read<AltmeChatSupportCubit>().setMessagesAsRead();
          }

          return BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, profileState) {
              final profileModel = profileState.model;

              final isEnterprise =
                  profileModel.walletType == WalletType.enterprise;

              final helpCenterOptions =
                  profileModel.profileSetting.helpCenterOptions;

              final displayChatSupport =
                  isEnterprise && helpCenterOptions.displayChatSupport;

              final displayNotification =
                  isEnterprise && helpCenterOptions.displayNotification;

              return PopScope(
                canPop: false,
                onPopInvoked: (didPop) async {
                  if (didPop) {
                    return;
                  }
                  if (scaffoldKey.currentState!.isDrawerOpen) {
                    // Navigator.of(context).pop();
                  }
                },
                child: BasePage(
                  scrollView: false,
                  scaffoldKey: scaffoldKey,
                  padding: EdgeInsets.zero,
                  drawer: const DrawerPage(),
                  body: Stack(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 15, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                HomeTitleLeading(
                                  onPressed: () {
                                    if (context
                                            .read<HomeCubit>()
                                            .state
                                            .homeStatus ==
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
                                if (Parameters.walletHandlesCrypto)
                                  const CryptoAccountSwitcherButton(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  ),
                                if (displayNotification)
                                  StreamBuilder(
                                    initialData: context
                                        .read<MatrixNotificationCubit>()
                                        .unreadMessageCount,
                                    stream: context
                                        .read<MatrixNotificationCubit>()
                                        .unreadMessageCountStream,
                                    builder: (_, snapShot) {
                                      return NotifyIcon(
                                        badgeCount: snapShot.data ?? 0,
                                        onTap: () {
                                          Navigator.of(context).push<void>(
                                            NotificationPage.route(),
                                          );
                                        },
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                          Text(
                            _getTitle(dashboardState.selectedIndex, l10n),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: PageView(
                              controller: pageController,
                              onPageChanged:
                                  context.read<DashboardCubit>().onPageChanged,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                const HomePage(),
                                // if (Parameters.walletHandlesCrypto)
                                //   const DiscoverTabPage()
                                // else
                                const DiscoverPage(),
                                if (Parameters.walletHandlesCrypto)
                                  const WertPage()
                                else
                                  const SearchPage(),
                                if (displayChatSupport)
                                  const AltmeSupportChatPage()
                                else
                                  Container(),
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
                                  isSelected: dashboardState.selectedIndex == 0,
                                ),
                                BottomBarItem(
                                  icon: IconStrings.discover,
                                  text: l10n.discover,
                                  onTap: () => bottomTapped(1),
                                  isSelected: dashboardState.selectedIndex == 1,
                                ),
                                const SizedBox(width: 60),
                                if (Parameters.walletHandlesCrypto)
                                  BottomBarItem(
                                    icon: IconStrings.cashInHand,
                                    text: l10n.buy,
                                    onTap: () => bottomTapped(2),
                                    isSelected:
                                        dashboardState.selectedIndex == 2,
                                  )
                                else
                                  BottomBarItem(
                                    icon: IconStrings.searchNormal,
                                    text: l10n.search,
                                    onTap: () => bottomTapped(2),
                                    isSelected:
                                        dashboardState.selectedIndex == 2,
                                  ),
                                if (displayChatSupport && isEnterprise) ...[
                                  StreamBuilder(
                                    initialData: context
                                        .read<AltmeChatSupportCubit>()
                                        .unreadMessageCount,
                                    stream: context
                                        .read<AltmeChatSupportCubit>()
                                        .unreadMessageCountStream,
                                    builder: (_, snapShot) {
                                      return BottomBarItem(
                                        icon: IconStrings.messaging,
                                        text: l10n.chat,
                                        badgeCount: snapShot.data ?? 0,
                                        onTap: () => bottomTapped(3),
                                        isSelected:
                                            dashboardState.selectedIndex == 3,
                                      );
                                    },
                                  ),
                                ] else ...[
                                  BottomBarItem(
                                    icon: IconStrings.settings,
                                    text: l10n.settings,
                                    onTap: () =>
                                        scaffoldKey.currentState!.openDrawer(),
                                    isSelected: false,
                                  ),
                                ],
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
        },
      ),
    );
  }
}
