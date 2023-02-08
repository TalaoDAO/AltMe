import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WhiteListPage extends StatefulWidget {
  const WhiteListPage({
    super.key,
  });

  static Route<String?> route() {
    return MaterialPageRoute<String?>(
      builder: (_) => const WhiteListPage(),
      settings: const RouteSettings(name: '/whiteListPage'),
    );
  }

  @override
  State<WhiteListPage> createState() => _WhiteListPageState();
}

class _WhiteListPageState extends State<WhiteListPage> {
  String? selectedWalletAddress;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      titleTrailing: const CryptoAccountSwitcherButton(),
      scrollView: false,
      body: BackgroundCard(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                l10n.sendTo,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: Sizes.spaceNormal,
              ),
              BlocBuilder<WalletCubit, WalletState>(
                builder: (context, walletState) {
                  final accounts = walletState.cryptoAccount.data
                      .where(
                        (element) =>
                            (element.blockchainType ==
                                walletState.currentAccount!.blockchainType) &&
                            (walletState.currentAccount != element),
                      )
                      .toList();
                  if (accounts.isEmpty) {
                    selectedWalletAddress = null;
                    return Center(
                      child: Text(l10n.thereIsNoAccountInYourWallet),
                    );
                  } else {
                    selectedWalletAddress = accounts.first.walletAddress;
                    return AccountSelectBoxView(
                      title: l10n.to,
                      accounts: accounts,
                      selectedAccountIndex: 0,
                      initiallyExpanded: true,
                      onSelectAccount: (accountData, index) {
                        selectedWalletAddress = accountData.walletAddress;
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      navigation: Padding(
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        child: MyElevatedButton(
          borderRadius: Sizes.normalRadius,
          text: l10n.next,
          onPressed: () {
            Navigator.pop(context, selectedWalletAddress);
          },
        ),
      ),
    );
  }
}
