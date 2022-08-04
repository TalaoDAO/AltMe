import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/withdrawal_tokens/withdrawal_tokens.dart';
import 'package:flutter/material.dart';

class TokenSelectBoxView extends StatelessWidget {
  const TokenSelectBoxView({Key? key, required this.initialToken})
      : super(key: key);

  final TokenModel initialToken;

  @override
  Widget build(BuildContext context) {
    return _TokenSelectBox(
      initialToken: initialToken,
    );
  }
}

class _TokenSelectBox extends StatefulWidget {
  const _TokenSelectBox({Key? key, required this.initialToken})
      : super(key: key);

  final TokenModel initialToken;

  @override
  State<_TokenSelectBox> createState() => _TokenSelectBoxState();
}

class _TokenSelectBoxState extends State<_TokenSelectBox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        SelectTokenBottomSheet.show(context);
      },
      child: Container(
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).hoverColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(Sizes.normalRadius),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(Sizes.smallRadius)),
                  child: SizedBox(
                    width: Sizes.icon2x,
                    height: Sizes.icon2x,
                    child: CachedImageFromNetwork(
                      widget.initialToken.iconUrl ?? '',
                    ),
                  ),
                ),
                const SizedBox(
                  width: Sizes.spaceXSmall,
                ),
                MyText(
                  widget.initialToken.name,
                  style: Theme.of(context).textTheme.listTileTitle,
                ),
                const SizedBox(
                  width: Sizes.spaceXSmall,
                ),
                Icon(
                  Icons.keyboard_arrow_down_outlined,
                  size: Sizes.icon,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                const Spacer(),
                MyText(
                  '${widget.initialToken.calculatedBalance} ${widget.initialToken.symbol}',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
            MyText(
              '\$134.65',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.greyText,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
