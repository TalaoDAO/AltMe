import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class WithdrawalAddressInput extends StatefulWidget {
  const WithdrawalAddressInput({Key? key, this.caption}) : super(key: key);

  final String? caption;

  @override
  State<WithdrawalAddressInput> createState() => _WithdrawalAddressInputState();
}

class _WithdrawalAddressInputState extends State<WithdrawalAddressInput> {
  final withdrawalAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(Sizes.spaceSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(Sizes.normalRadius),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.caption != null)
            Text(
              widget.caption!,
              style: Theme.of(context).textTheme.caption?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: withdrawalAddressController,
                  style: Theme.of(context).textTheme.labelMedium,
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: l10n.withdrawalInputHint,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(
                width: Sizes.spaceSmall,
              ),
              Image.asset(
                IconStrings.scanAddress,
                width: Sizes.icon2x,
              ),
              const SizedBox(
                width: Sizes.spaceSmall,
              ),
              Image.asset(
                IconStrings.whiteList,
                width: Sizes.icon2x,
              ),
            ],
          )
        ],
      ),
    );
  }
}
