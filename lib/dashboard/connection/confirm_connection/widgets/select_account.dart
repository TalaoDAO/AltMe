import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectAccount extends StatelessWidget {
  const SelectAccount({
    Key? key,
    required this.blockchainType,
  }) : super(key: key);

  final BlockchainType blockchainType;

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
                return cryptoAccountData.blockchainType == blockchainType
                    ? SelectBoxAccountItem(
                        cryptoAccountData: cryptoAccountData,
                        isSelected: walletState.currentCryptoIndex == i,
                        listIndex: i,
                        onPressed: () {
                          context
                              .read<WalletCubit>()
                              .setCurrentWalletAccount(i);
                        },
                      )
                    : Container();
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
