import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:decimal/decimal.dart';

import 'package:flutter/material.dart';

class FeeDetails extends StatelessWidget {
  const FeeDetails({
    super.key,
    required this.amount,
    required this.tokenUSDRate,
    required this.symbol,
    required this.totalFee,
    this.bakerFee,
  });

  final String amount;
  final double tokenUSDRate;
  final String symbol;
  final String totalFee;
  final String? bakerFee;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final grandTotal =
        (Decimal.parse(amount) + Decimal.parse(totalFee)).toDouble();

    final bakerCost =
        bakerFee == null ? null : Decimal.parse(bakerFee!).toDouble();
    final storageFee = bakerFee == null
        ? null
        : (Decimal.parse(totalFee) - Decimal.parse(bakerFee!)).toDouble();

    return BackgroundCard(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                l10n.amount,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              Text(
                '${amount.decimalNumber(6).formatNumber} $symbol',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          _buildDivider(context),
          if (bakerCost != null && storageFee != null) ...[
            Row(
              children: [
                Text(
                  l10n.bakerFee,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                Text(
                  '${bakerCost.decimalNumber(6).formatNumber} $symbol',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            _buildDivider(context),
            Row(
              children: [
                Text(
                  l10n.storageFee,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                Text(
                  '${storageFee.decimalNumber(6).formatNumber}'
                  ' $symbol',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Text(
                  l10n.networkFee,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                Text(
                  '${totalFee.decimalNumber(6).formatNumber} $symbol',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
          _buildDivider(context),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.totalAmount,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '''${grandTotal.decimalNumber(6).formatNumber} $symbol''',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (tokenUSDRate > 0)
                    Text(
                      r'$' +
                          (grandTotal * tokenUSDRate)
                              .decimalNumber(6)
                              .formatNumber,
                      style: Theme.of(context).textTheme.bodyMedium,
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
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
      ),
    );
  }
}
