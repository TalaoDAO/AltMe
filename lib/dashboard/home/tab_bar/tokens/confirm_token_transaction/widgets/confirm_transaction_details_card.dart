import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/tokens/tokens.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

class ConfirmTransactionDetailsCard extends StatelessWidget {
  const ConfirmTransactionDetailsCard({
    super.key,
    required this.amount,
    required this.tokenUSDRate,
    required this.symbol,
    required this.networkFee,
    required this.grandTotal,
    this.networkFees,
    this.onEditButtonPressed,
    this.isNFT = false,
  });

  final String amount;
  final double tokenUSDRate;
  final String symbol;
  final NetworkFeeModel? networkFee;
  final List<NetworkFeeModel>? networkFees;
  final VoidCallback? onEditButtonPressed;
  final bool isNFT;
  final String grandTotal;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BackgroundCard(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.amountSent,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '''${isNFT ? Decimal.parse(grandTotal).toBigInt() : double.parse(grandTotal).decimalNumber(getDecimalsToShow(double.parse(grandTotal))).formatNumber} $symbol''',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (tokenUSDRate > 0)
                    Text(
                      r'$' +
                          (double.parse(grandTotal) * tokenUSDRate)
                              .decimalNumber(2)
                              .formatNumber,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
            ],
          ),
          if (networkFee != null) _buildDivider(context),
          if (networkFee != null)
            Row(
              children: [
                Text(
                  l10n.networkFee,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(
                  width: Sizes.spaceXSmall,
                ),
                if (networkFees != null)
                  EditButton(
                    onTap: onEditButtonPressed,
                  ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '''${networkFee!.fee.decimalNumber(6).formatNumber} ${networkFee!.tokenSymbol}''',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (tokenUSDRate > 0 && networkFee?.tokenSymbol == symbol)
                      Text(
                        r'$' +
                            networkFee!.feeInUSD.decimalNumber(2).formatNumber,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '''${isNFT ? Decimal.parse(amount).toBigInt() : double.parse(amount).decimalNumber(getDecimalsToShow(double.parse(amount))).formatNumber} $symbol''',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (tokenUSDRate > 0)
                    Text(
                      r'$' +
                          (double.parse(amount) * tokenUSDRate)
                              .decimalNumber(2)
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
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
      ),
    );
  }

  int getDecimalsToShow(double amount) {
    return amount >= 1 ? 2 : 6;
  }
}
