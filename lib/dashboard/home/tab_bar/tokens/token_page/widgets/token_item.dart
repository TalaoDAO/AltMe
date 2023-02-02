import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class TokenItem extends StatelessWidget {
  const TokenItem({
    super.key,
    required this.token,
    this.isSecure = false,
  });

  final TokenModel token;
  final bool isSecure;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: BackgroundCard(
        color: Theme.of(context).colorScheme.surfaceContainer,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          minVerticalPadding: 0,
          leading: CachedImageFromNetwork(
            token.iconUrl ?? '',
            width: Sizes.tokenLogoSize,
            height: Sizes.tokenLogoSize,
            borderRadius: const BorderRadius.all(
              Radius.circular(Sizes.tokenLogoSize),
            ),
          ),
          title: MyText(
            token.name.isEmpty ? token.symbol : token.name,
            style: Theme.of(context).textTheme.listTileTitle,
            maxLength: 10,
          ),
          subtitle: MyText(
            token.symbol,
            style: Theme.of(context).textTheme.listTileSubtitle,
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: MyText(
                  isSecure
                      ? '****'
                      : ('''${token.calculatedBalanceInDouble.toStringAsFixed(token.decimalsToShow).formatNumber()} ${token.symbol}'''),
                  style: Theme.of(context)
                      .textTheme
                      .listTileTitle
                      .copyWith(fontSize: 13),
                ),
              ),
              Flexible(
                child: MyText(
                  isSecure
                      ? '****'
                      : (r'$' +
                          token.balanceInUSD.toStringAsFixed(2).formatNumber()),
                  style: Theme.of(context).textTheme.listTileSubtitle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
