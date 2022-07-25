import 'package:altme/app/app.dart';
import 'package:altme/crypto_bottom_sheet/crypto_bottom_sheet.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTitleTrailing extends StatelessWidget {
  const HomeTitleTrailing({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, walletState) {
        final currentIndex = walletState.currentCryptoIndex;

        String accountName = l10n.unknown;

        if (walletState.cryptoAccount.data.isNotEmpty) {
          accountName = walletState.cryptoAccount.data[currentIndex].name;
        }

        return (walletState.cryptoAccount.data.isNotEmpty &&
                walletState
                    .cryptoAccount.data[currentIndex].walletAddress.isNotEmpty)
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
    );
  }
}
