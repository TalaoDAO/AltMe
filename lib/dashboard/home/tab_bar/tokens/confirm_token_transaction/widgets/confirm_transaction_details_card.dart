import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/tokens/tokens.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class ConfirmTransactionDetailsCard extends StatelessWidget {
  const ConfirmTransactionDetailsCard({
    Key? key,
    required this.amount,
    required this.tokenUSDRate,
    required this.symbol,
    required this.networkFee,
    required this.grandTotal,
    this.networkFees,
    this.onEditButtonPressed,
    this.isNFT = false,
  }) : super(key: key);

  final double amount;
  final double tokenUSDRate;
  final String symbol;
  final NetworkFeeModel? networkFee;
  final List<NetworkFeeModel>? networkFees;
  final VoidCallback? onEditButtonPressed;
  final bool isNFT;
  final double grandTotal;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '''${isNFT ? amount.toInt() : amount.toStringAsFixed(getDecimalsToShow(amount)).formatNumber()} $symbol''',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  if (tokenUSDRate > 0)
                    Text(
                      r'$' +
                          (amount * tokenUSDRate)
                              .toStringAsFixed(2)
                              .formatNumber(),
                      style: Theme.of(context).textTheme.caption2,
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
                  style: Theme.of(context).textTheme.caption,
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
                      '''${networkFee!.fee.toStringAsFixed(6).formatNumber()} ${networkFee!.tokenSymbol}''',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    if (tokenUSDRate > 0 && networkFee?.tokenSymbol == symbol)
                      Text(
                        r'$' +
                            networkFee!.feeInUSD
                                .toStringAsFixed(2)
                                .formatNumber(),
                        style: Theme.of(context).textTheme.caption2,
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
                style: Theme.of(context).textTheme.caption,
              ),
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '''${isNFT ? grandTotal.toInt() : grandTotal.toStringAsFixed(getDecimalsToShow(grandTotal)).formatNumber()} $symbol''',
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

  int getDecimalsToShow(double amount) {
    return amount >= 1
            ? 2
            : 5;
  }
}
