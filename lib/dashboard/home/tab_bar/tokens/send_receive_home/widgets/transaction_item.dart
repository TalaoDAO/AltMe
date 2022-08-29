import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.operationModel,
    required this.decimal,
    required this.symbol,
    this.tokenUsdPrice,
  }) : super(key: key);

  final OperationModel operationModel;
  final int decimal;
  final double? tokenUsdPrice;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final amount = operationModel.calcAmount(
      decimal: decimal,
      value: operationModel.parameter?.value?.value ??
          operationModel.amount.toString(),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: Sizes.spaceXSmall,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              operationModel.formatedDateTime,
              style: Theme.of(context).textTheme.caption2,
            ),
            Text(
              tokenUsdPrice != null
                  ? (tokenUsdPrice! * amount)
                          .toStringAsFixed(2)
                          .formatNumber() +
                      r'$'
                  : r'$--.--',
              style: Theme.of(context).textTheme.caption2,
            ),
          ],
        ),
        const SizedBox(
          height: Sizes.spaceXSmall,
        ),
        Row(
          children: [
            Image.asset(
              operationModel.isSender(
                walletAddress: context
                    .read<WalletCubit>()
                    .state
                    .currentAccount
                    .walletAddress,
              )
                  ? IconStrings.send
                  : IconStrings.receive,
              width: Sizes.icon,
              height: Sizes.icon,
            ),
            const SizedBox(
              width: Sizes.space2XSmall,
            ),
            Text(
              operationModel.isSender(
                walletAddress: context
                    .read<WalletCubit>()
                    .state
                    .currentAccount
                    .walletAddress,
              )
                  ? l10n.send
                  : l10n.receive,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(
              width: Sizes.space2XSmall,
            ),
            Text(
              operationModel.status,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const Spacer(),
            MyText(
              '${amount.toStringAsFixed(2).formatNumber()} '
              '$symbol',
              minFontSize: 8,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        )
      ],
    );
  }
}
