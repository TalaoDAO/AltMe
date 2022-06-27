import 'package:altme/app/app.dart';
import 'package:altme/home/crypto_bottom_sheet/cubit/crypto_bottom_sheet_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CryptoBottomSheetView extends StatelessWidget {
  const CryptoBottomSheetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, walletState) {
        final l10n = context.l10n;
        final List<CryptoAccountData> cryptoAccount =
            walletState.cryptoAccount.data;

        final activeIndex = walletState.currentCryptoIndex;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  l10n.cryptoAccounts,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(height: 10),
                ListView.builder(
                  itemCount: cryptoAccount.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    final cryptoAccountData = cryptoAccount[i];
                    final walletAddress = cryptoAccountData.walletAddress;

                    final walletAddressExtracted = walletAddress != ''
                        ? '''${walletAddress.substring(0, 5)} ... ${walletAddress.substring(walletAddress.length - 5)}'''
                        : '';

                    return InkWell(
                      onTap: () {
                        context.read<WalletCubit>().setCurrentWalletAccount(i);
                      },
                      child: Container(
                        color: activeIndex == i
                            ? Colors.purple
                            : Colors.grey.withOpacity(0.2),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${l10n.cryptoAccount} ${i + 1}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  walletAddressExtracted,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Container(height: 20),
                MyElevatedButton(
                  text: l10n.cryptoAddAccount,
                  verticalSpacing: 8,
                  fontSize: 15,
                  onPressed: () async {
                    await context
                        .read<CryptoBottomSheetCubit>()
                        .addCryptoAccount();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
