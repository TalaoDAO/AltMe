import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectAccount extends StatelessWidget {
  const SelectAccount({
    super.key,
    required this.connectionBridgeType,
  });

  final ConnectionBridgeType connectionBridgeType;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.selectAccountToGrantAccess,
          style: Theme.of(context).textTheme.beaconSelectAccont,
        ),
        BlocBuilder<WalletCubit, WalletState>(
          builder: (context, walletState) {
            return ListView.separated(
              itemCount: walletState.cryptoAccount.data.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                final cryptoAccountData = walletState.cryptoAccount.data[i];

                if (connectionBridgeType == ConnectionBridgeType.beacon) {
                  if (cryptoAccountData.blockchainType !=
                      BlockchainType.tezos) {
                    // beacon and ethereum, matic, polygon, binance
                    return Container();
                  }
                } else {
                  if (cryptoAccountData.blockchainType ==
                      BlockchainType.tezos) {
                    // wallet-connect and tezos
                    return Container();
                  }
                }

                return SelectBoxAccountItem(
                  cryptoAccountData: cryptoAccountData,
                  isSelected: walletState.currentCryptoIndex == i,
                  listIndex: i,
                  onPressed: () {
                    context.read<WalletCubit>().setCurrentWalletAccount(i);
                  },
                );
              },
              separatorBuilder: (_, __) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.spaceSmall,
                ),
                child: Divider(
                  height: 0.2,
                  color: Theme.of(context).colorScheme.borderColor,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
