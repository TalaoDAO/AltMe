import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/tokens/tokens.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:flutter/material.dart';

class SelectNetworkFeeItem extends StatelessWidget {
  const SelectNetworkFeeItem({
    super.key,
    required this.networkFeeModel,
    required this.isSelected,
    required this.onPressed,
  });

  final NetworkFeeModel networkFeeModel;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListTile(
      onTap: onPressed,
      contentPadding: const EdgeInsets.symmetric(vertical: Sizes.space2XSmall),
      horizontalTitleGap: 0,
      leading: Checkbox(
        value: isSelected,
        fillColor: WidgetStateProperty.all(
          Theme.of(context).colorScheme.inversePrimary,
        ),
        checkColor: Theme.of(context).colorScheme.primary,
        onChanged: (_) => onPressed.call(),
        shape: const CircleBorder(),
      ),
      title: MyText(
        getNetworkFeeSpeedTitle(l10n, networkFeeModel.networkSpeed),
        maxLines: 1,
        minFontSize: 12,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          MyText(
            '''${networkFeeModel.totalFee.formatNumber} ${networkFeeModel.tokenSymbol}''',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(
            height: Sizes.space2XSmall,
          ),
          MyText(
            '''\$${networkFeeModel.feeInUSD == 0.0 ? '--.--' : networkFeeModel.feeInUSD.decimalNumber(4).formatNumber}''',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  String getNetworkFeeSpeedTitle(AppLocalizations l10n, NetworkSpeed speed) {
    switch (speed) {
      case NetworkSpeed.slow:
        return l10n.slow;
      case NetworkSpeed.average:
        return l10n.average;
      case NetworkSpeed.fast:
        return l10n.fast;
    }
  }
}
