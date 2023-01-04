import 'package:altme/app/app.dart';
import 'package:altme/dashboard/drawer/manage_network/cubit/manage_network_cubit.dart';
import 'package:altme/dashboard/home/tab_bar/tokens/tokens.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmTransactionDetailsCard extends StatelessWidget {
  const ConfirmTransactionDetailsCard({
    Key? key,
    required this.amount,
    required this.tokenUSDRate,
    required this.symbol,
    required this.networkFee,
    this.onEditButtonPressed,
    this.isNFT = false,
  }) : super(key: key);

  final double amount;
  final double tokenUSDRate;
  final String symbol;
  final NetworkFeeModel networkFee;
  final VoidCallback? onEditButtonPressed;
  final bool isNFT;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final double grandTotal =
        symbol.toLowerCase() == 'xtz' ? (amount + networkFee.fee) : amount;
    return BackgroundCard(
      color: Theme.of(context).colorScheme.cardBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                l10n.amount,
                style: Theme.of(context).textTheme.caption,
              ),
              const Spacer(),
              Text(
                '''${isNFT ? amount.toInt() : amount.toStringAsFixed(6).formatNumber()} $symbol''',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
          if (context.read<ManageNetworkCubit>().state.network is TezosNetwork)
            _buildDivider(context),
          if (context.read<ManageNetworkCubit>().state.network is TezosNetwork)
            Row(
              children: [
                Text(
                  l10n.networkFee,
                  style: Theme.of(context).textTheme.caption,
                ),
                const SizedBox(
                  width: Sizes.spaceXSmall,
                ),
                EditButton(
                  onTap: onEditButtonPressed,
                ),
                const Spacer(),
                Text(
                  '''${networkFee.fee.toStringAsFixed(6).formatNumber()} ${networkFee.tokenSymbol}''',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          _buildDivider(context),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.totalAmount,
                style: Theme.of(context).textTheme.caption,
              ),
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '''${isNFT ? grandTotal.toInt() : grandTotal.toStringAsFixed(6).formatNumber()} $symbol''',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  if (tokenUSDRate > 0)
                    Text(
                      r'$' +
                          (grandTotal * tokenUSDRate)
                              .toStringAsFixed(2)
                              .formatNumber(),
                      style: Theme.of(context).textTheme.caption2,
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Sizes.spaceSmall,
      ),
      child: Divider(
        height: 0.1,
        color: Theme.of(context).colorScheme.borderColor,
      ),
    );
  }
}
