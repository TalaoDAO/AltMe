import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.operationModel,
    required this.decimal,
    required this.symbol,
    this.tokenUsdPrice,
    this.onTap,
  });

  final OperationModel operationModel;
  final int decimal;
  final double? tokenUsdPrice;
  final String symbol;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final amount = operationModel.calcAmount(
      decimal: decimal,
      value: operationModel.parameter?.value?.value ??
          operationModel.amount.toString(),
    );
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: Sizes.spaceXSmall,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                operationModel.formatedDateTime,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              Text(
                l10n.seeTransaction,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                width: Sizes.spaceSmall,
              ),
              Text(
                tokenUsdPrice != null
                    ? (tokenUsdPrice! * amount).decimalNumber(2).formatNumber +
                        r'$'
                    : r'$--.--',
                style: Theme.of(context).textTheme.bodyMedium,
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
                      .currentAccount!
                      .walletAddress,
                )
                    ? IconStrings.send
                    : IconStrings.receive,
                width: Sizes.icon,
                height: Sizes.icon,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(
                width: Sizes.space2XSmall,
              ),
              Text(
                operationModel.isSender(
                  walletAddress: context
                      .read<WalletCubit>()
                      .state
                      .currentAccount!
                      .walletAddress,
                )
                    ? l10n.send
                    : l10n.receive,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                width: Sizes.space2XSmall,
              ),
              Text(
                operationModel.status,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: operationModel.status.toLowerCase() == 'applied'
                          ? Theme.of(context).colorScheme.secondary
                          : operationModel.status.toLowerCase() == 'failed' ||
                                  operationModel.status.toLowerCase() ==
                                      'backtracked'
                              ? Theme.of(context).colorScheme.error
                              : operationModel.status.toLowerCase() == 'skipped'
                                  ? Theme.of(context).colorScheme.error
                                  : null,
                    ),
              ),
              const SizedBox(
                width: Sizes.space2XSmall,
              ),
              Expanded(
                child: MyText(
                  '''${amount.decimalNumber(amount < 1 ? 5 : 2).formatNumber} '''
                  '$symbol',
                  minFontSize: 8,
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
