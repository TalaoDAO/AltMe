import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/enterprise/cubit/enterprise_cubit.dart';
import 'package:altme/kyc_verification/kyc_verification.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/matrix_notification/matrix_notification.dart';
import 'package:altme/splash/cubit/splash_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_ui/wallet_ui.dart';

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

/// The page shown inside the dashboard for [tab].
Widget buildDashboardTab(DashboardTab tab) => switch (tab) {
  DashboardTab.wallet => const HomePage(),
  DashboardTab.discover => const DiscoverPage(),
  DashboardTab.search =>
    Parameters.walletHandlesCrypto ? const WertPage() : const SearchPage(),
};

class DashboardView extends StatefulWidget {
  const DashboardView({super.key, this.tabBuilder = buildDashboardTab});

  /// Builds the page of each tab. Tests replace the real pages.
  final Widget Function(DashboardTab tab) tabBuilder;

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

/// The bottom bar destinations, left to right. `null` is Present, which
/// pushes the scanner instead of showing a tab.
const _barDestinations = <DashboardTab?>[
  DashboardTab.wallet,
  DashboardTab.discover,
  null,
  DashboardTab.search,
];

class _DashboardViewState extends State<DashboardView> {
  final PageController pageController = PageController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Whatever the way here (PIN, onboarding, wallet import), the wallet is
      // unlocked: the links waiting for it can be processed.
      context.read<SplashCubit>().authenticated();
      Future.delayed(Duration.zero, () {
        if (!mounted) return;

        /// If there is a deepLink we give do as if it coming from QRCode
        context.read<QRCodeScanCubit>().deepLink();

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

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _selectTab(DashboardTab tab) {
    if (!ensureWallet(context)) return;
    context.read<DashboardCubit>().selectTab(tab);
  }

  /// Pushes the scanner on [tab]: Scan from the centre button, Present from
  /// the Present destination.
  void _openScanner(ScanPageTab tab) {
    if (kIsWeb) {
      final l10n = context.l10n;
      unawaited(
        showDialog<void>(
          context: context,
          builder: (_) => ConfirmDialog(
            title: l10n.unavailable_feature_title,
            subtitle: l10n.unavailable_feature_message,
            yes: l10n.ok,
            showNoButton: false,
          ),
        ),
      );
      return;
    }
    if (!ensureWallet(context)) return;
    unawaited(
      Navigator.of(context).push<void>(QrCodeScanPage.route(initialTab: tab)),
    );
  }

  void _onBarSelected(int index) {
    final tab = _barDestinations[index];
    if (tab == null) {
      _openScanner(ScanPageTab.present);
    } else {
      _selectTab(tab);
    }
  }

  String _title(DashboardTab tab, AppLocalizations l10n) => switch (tab) {
    DashboardTab.wallet => l10n.myWallet,
    DashboardTab.discover => l10n.discover,
    DashboardTab.search =>
      Parameters.walletHandlesCrypto ? l10n.buy : l10n.search,
  };

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
                      onSuccess: () => Navigator.of(
                        context,
                      ).push<void>(RecoveryKeyPage.route()),
                    );
                  },
                ),
              );
            }
          },
        ),
        BlocListener<DashboardCubit, DashboardState>(
          listenWhen: (previous, current) => previous.tab != current.tab,
          listener: (_, state) {
            if (pageController.hasClients) {
              pageController.jumpToPage(state.tab.index);
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
          final tab = dashboardState.tab;
          final displayNotification = context.select<ProfileCubit, bool>(
            (cubit) => cubit
                .state
                .model
                .profileSetting
                .helpCenterOptions
                .displayNotification,
          );
          final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (didPop) return;
              // Back from another tab goes to Wallet; on Wallet it does
              // nothing.
              if (tab != DashboardTab.wallet) {
                context.read<DashboardCubit>().selectTab(DashboardTab.wallet);
              }
            },
            child: Scaffold(
              // The body ends above the bar, so the content gets a bottom
              // padding of the bar height plus `viewPadding.bottom`, and
              // snackbars sit above the bar.
              bottomNavigationBar: keyboardOpen
                  ? null
                  : WalletBottomBar(
                      items: [
                        WalletBottomBarItem(
                          icon: const WalletIcon(
                            WalletIconStrings.walletInactive,
                          ),
                          activeIcon: const WalletIcon(
                            WalletIconStrings.wallet,
                          ),
                          label: l10n.wallet,
                          semanticLabel: l10n.wallet,
                        ),
                        WalletBottomBarItem(
                          icon: const WalletIcon(
                            WalletIconStrings.exploreInactive,
                          ),
                          activeIcon: const WalletIcon(
                            WalletIconStrings.explore,
                          ),
                          label: l10n.discover,
                          semanticLabel: l10n.discover,
                        ),
                        WalletBottomBarItem(
                          icon: const WalletIcon(
                            WalletIconStrings.sensorsInactive,
                          ),
                          activeIcon: const WalletIcon(
                            WalletIconStrings.sensors,
                          ),
                          label: l10n.mdocPresent,
                          semanticLabel: l10n.mdocPresent,
                        ),
                        if (Parameters.walletHandlesCrypto)
                          WalletBottomBarItem(
                            icon: const WalletIcon(
                              WalletIconStrings.creditCardInactive,
                            ),
                            activeIcon: const WalletIcon(
                              WalletIconStrings.creditCard,
                            ),
                            label: l10n.buy,
                            semanticLabel: l10n.buy,
                          )
                        else
                          WalletBottomBarItem(
                            icon: const WalletIcon(WalletIconStrings.search),
                            activeIcon: const WalletIcon(
                              WalletIconStrings.search,
                            ),
                            label: l10n.search,
                            semanticLabel: l10n.search,
                          ),
                      ],
                      selectedIndex: _barDestinations.indexOf(tab),
                      onSelected: _onBarSelected,
                      centerButton: WalletBottomBarCenterButton(
                        icon: const WalletIcon(WalletIconStrings.eyeTracking),
                        semanticLabel: l10n.scanQrCode,
                        onPressed: () => _openScanner(ScanPageTab.scan),
                      ),
                    ),
              body: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        WalletSpacing.m,
                        0,
                        WalletSpacing.s,
                        0,
                      ),
                      child: Row(
                        children: [
                          if (Parameters.walletHandlesCrypto)
                            const CryptoAccountSwitcherButton(
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          Expanded(
                            child: Text(
                              _title(tab, l10n),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headlineSmall!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
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
                                    Navigator.of(
                                      context,
                                    ).push<void>(NotificationPage.route());
                                  },
                                );
                              },
                            ),
                          IconButton(
                            tooltip: l10n.settings,
                            icon: const WalletIcon(WalletIconStrings.dehaze),
                            onPressed: () {
                              if (!ensureWallet(context)) return;
                              Navigator.of(
                                context,
                              ).push<void>(SettingsPage.route());
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        controller: pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          for (final tab in DashboardTab.values)
                            widget.tabBuilder(tab),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
