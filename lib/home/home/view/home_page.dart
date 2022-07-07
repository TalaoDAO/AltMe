import 'package:altme/app/app.dart';
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
    return WillPopScope(
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

            String accountName = '';

            if (state.cryptoAccount.data.isNotEmpty) {
              accountName = state.cryptoAccount.data[currentIndex].name;
            }

            return (state.cryptoAccount.data.isNotEmpty &&
                    state.cryptoAccount.data[currentIndex].walletAddress
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
    );
  }
}
