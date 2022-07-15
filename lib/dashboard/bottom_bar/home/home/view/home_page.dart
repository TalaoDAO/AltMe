import 'package:altme/app/app.dart';
import 'package:altme/crypto_bottom_sheet/crypto_bottom_sheet.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => const HomePage(),
        settings: const RouteSettings(name: '/homePage'),
      );

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      /// If there is a deepLink we give do as if it coming from QRCode
      context.read<QRCodeScanCubit>().deepLink();
    });
    super.initState();
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
    return WillPopScope(
      onWillPop: () async {
        if (scaffoldKey.currentState!.isDrawerOpen) {
          Navigator.of(context).pop();
        }
        return false;
      },
      child: BlocListener<HomeCubit, HomeState>(
        listener: (context, homeState) {
          if (homeState.status == AppStatus.loading) {
            LoadingView().show(context: context);
          } else {
            LoadingView().hide();
          }

          if (homeState.message != null) {
            AlertMessage.showStateMessage(
              context: context,
              stateMessage: homeState.message!,
            );
          }

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

          if (homeState.status == AppStatus.success) {
            showDialog<void>(
              context: context,
              builder: (_) => const FinishKycDialog(),
            );
          }
        },
        child: BasePage(
          scrollView: false,
          scaffoldKey: scaffoldKey,
          drawer: const DrawerPage(),
          padding: EdgeInsets.zero,
          titleLeading: IconButton(
            icon: ImageIcon(
              const AssetImage(IconStrings.icMenu),
              color: Theme.of(context).colorScheme.leadingButton,
            ),
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
          titleTrailing: BlocBuilder<WalletCubit, WalletState>(
            builder: (context, walletState) {
              final currentIndex = walletState.currentCryptoIndex;

              String accountName = '';

              if (walletState.cryptoAccount.data.isNotEmpty) {
                accountName = walletState.cryptoAccount.data[currentIndex].name;
              }

              return (walletState.cryptoAccount.data.isNotEmpty &&
                      walletState.cryptoAccount.data[currentIndex].walletAddress
                          .isNotEmpty)
                  ? InkWell(
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(Sizes.largeRadius),
                              topLeft: Radius.circular(Sizes.largeRadius),
                            ),
                          ),
                          builder: (context) => const CryptoBottomSheetView(),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                accountName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Image.asset(
                            IconStrings.arrowSquareDown,
                            width: Sizes.icon,
                          ),
                        ],
                      ),
                    )
                  : const Center();
            },
          ),
          body: Stack(
            children: [
              Column(
                children: const [
                  Expanded(child: TabControllerPage()),
                  BottomBarPage()
                ],
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: QRIcon(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
