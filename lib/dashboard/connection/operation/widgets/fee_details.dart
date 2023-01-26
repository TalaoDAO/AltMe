import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class FeeDetails extends StatelessWidget {
  const FeeDetails({
    super.key,
    required this.amount,
    required this.tokenUSDRate,
    required this.symbol,
    required this.fee,
  });

  final double amount;
  final double tokenUSDRate;
  final String symbol;
  final double fee;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final double grandTotal = amount + fee;
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
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              Text(
                '${amount.toStringAsFixed(6).formatNumber()}  $symbol',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          _buildDivider(context),
          Row(
            children: [
              Text(
                l10n.fee,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              Text(
                '${fee.toStringAsFixed(6).formatNumber()} $symbol',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
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
                    '''${grandTotal.toStringAsFixed(6).formatNumber()} $symbol''',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (tokenUSDRate > 0)
                    Text(
                      r'$' +
                          (grandTotal * tokenUSDRate)
                              .toStringAsFixed(6)
                              .formatNumber(),
                      style: Theme.of(context).textTheme.bodySmall2,
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
