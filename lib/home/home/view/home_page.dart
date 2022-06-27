import 'package:altme/app/app.dart';
import 'package:altme/home/crypto_bottom_sheet/crypto_bottom_sheet.dart';
import 'package:altme/home/home.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  OverlayEntry? _overlay;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      /// If there is a deepLink we give do as if it coming from QRCode
      context.read<QRCodeScanCubit>().deepLink();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CryptoBottomSheetCubit, CryptoBottomSheetState>(
      listener: (context, state) {
        if (state.status == AppStatus.loading) {
          _overlay = OverlayEntry(
            builder: (_) => const LoadingDialog(),
          );
          Overlay.of(context)!.insert(_overlay!);
        } else {
          if (_overlay != null) {
            _overlay!.remove();
            _overlay = null;
          }
        }

        if (state.message != null) {
          AlertMessage.showStateMessage(
            context: context,
            stateMessage: state.message!,
          );
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          if (scaffoldKey.currentState!.isDrawerOpen) {
            Navigator.of(context).pop();
          }
          return false;
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
              if (context.read<HomeCubit>().state == HomeStatus.hasNoWallet) {
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
            builder: (context, state) {
              final currentIndex = state.currentCryptoIndex;

              String walletAddressExtracted = '';

              if (state.cryptoAccount.data.isNotEmpty) {
                final walletAddress =
                    state.cryptoAccount.data[currentIndex].walletAddress;

                walletAddressExtracted = walletAddress != ''
                    ? '''${walletAddress.substring(0, 5)} ... ${walletAddress.substring(walletAddress.length - 5)}'''
                    : '';
              }

              return walletAddressExtracted == ''
                  ? const SizedBox.shrink()
                  : InkWell(
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (context) => const CryptoBottomSheetView(),
                        );
                      },
                      child: Row(
                        children: [
                          Text(walletAddressExtracted),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                          )
                        ],
                      ),
                    );
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
