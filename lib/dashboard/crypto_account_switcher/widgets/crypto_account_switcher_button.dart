import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CryptoAccountSwitcherButton extends StatelessWidget {
  const CryptoAccountSwitcherButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, walletState) {
        final currentIndex = walletState.currentCryptoIndex;

        String accountName = l10n.unknown;
        BlockchainType? blockchainType;

        if (walletState.cryptoAccount.data.isNotEmpty) {
          accountName = walletState.cryptoAccount.data[currentIndex].name;
          blockchainType =
              walletState.cryptoAccount.data[currentIndex].blockchainType;
        }

        return (walletState.cryptoAccount.data.isNotEmpty &&
                walletState
                    .cryptoAccount.data[currentIndex].walletAddress.isNotEmpty)
            ? Flexible(
                child: InkWell(
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (blockchainType != null) ...[
                        Image.asset(
                          blockchainType.icon,
                          width: Sizes.icon,
                        ),
                        const SizedBox(width: 5),
                      ],
                      Flexible(
                        child: MyText(
                          accountName,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Image.asset(
                        IconStrings.arrowSquareDown,
                        width: Sizes.icon,
                      ),
                    ],
                  ),
                ),
              )
            : const Center();
      },
    );
  }
}
