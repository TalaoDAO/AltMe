import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class TokenSelectBoxView extends StatelessWidget {
  const TokenSelectBoxView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _TokenSelectBox();
  }
}

class _TokenSelectBox extends StatefulWidget {
  const _TokenSelectBox({Key? key}) : super(key: key);

  @override
  State<_TokenSelectBox> createState() => _TokenSelectBoxState();
}

class _TokenSelectBoxState extends State<_TokenSelectBox> {
  final tempModel = const TokenModel(
    'contractAddress',
    'Tezos',
    'XTZ',
    'https://s2.coinmarketcap.com/static/img/coins/64x64/2011.png',
    null,
    '12345667',
    '6',
  );

  @override
  Widget build(BuildContext context) {
    return Container(
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
                borderRadius:
                    const BorderRadius.all(Radius.circular(Sizes.smallRadius)),
                child: SizedBox(
                  width: Sizes.icon2x,
                  height: Sizes.icon2x,
                  child: CachedImageFromNetwork(
                    tempModel.iconUrl ?? '',
                  ),
                ),
              ),
              const SizedBox(
                width: Sizes.spaceXSmall,
              ),
              MyText(
                tempModel.name,
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
                '${tempModel.calculatedBalance} ${tempModel.symbol}',
                style: Theme.of(context)
                    .textTheme
                    .caption,
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
    );
  }
}
