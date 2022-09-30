import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/home/tab_bar/tokens/tokens.dart';
import 'package:arago_wallet/l10n/l10n.dart';
import 'package:arago_wallet/theme/theme.dart';
import 'package:flutter/material.dart';

class ConfirmDetailsCard extends StatelessWidget {
  const ConfirmDetailsCard({
    Key? key,
    required this.amount,
    required this.tokenUSDRate,
    required this.symbol,
    required this.networkFee,
    this.onEditButtonPressed,
  }) : super(key: key);

  final double amount;
  final double tokenUSDRate;
  final String symbol;
  final NetworkFeeModel networkFee;
  final VoidCallback? onEditButtonPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final double grandTotal = amount + networkFee.fee;
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
                '${amount.toStringAsFixed(6).formatNumber()} $symbol',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
          _buildDivider(context),
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
                    '''${grandTotal.toStringAsFixed(6).formatNumber()} $symbol''',
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
