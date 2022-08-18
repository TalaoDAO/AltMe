import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class TokenItem extends StatelessWidget {
  const TokenItem({
    Key? key,
    required this.token,
    this.isSecure = false,
  }) : super(key: key);

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
          leading: token.iconUrl == null
              ? Container(
                  width: Sizes.tokenLogoSize,
                  height: Sizes.tokenLogoSize,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(Sizes.tokenLogoSize),
                    ),
                  ),
                )
              : CachedImageFromNetwork(
                  token.iconUrl!,
                  width: Sizes.tokenLogoSize,
                  height: Sizes.tokenLogoSize,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(Sizes.tokenLogoSize),
                  ),
                ),
          title: MyText(
            token.symbol,
            style: Theme.of(context).textTheme.listTileTitle,
          ),
          subtitle: MyText(
            token.name.isEmpty ? token.symbol : token.name,
            style: Theme.of(context).textTheme.listTileSubtitle,
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MyText(
                isSecure ? '****' : token.calculatedBalance,
                style: Theme.of(context)
                    .textTheme
                    .listTileTitle
                    .copyWith(fontSize: 13),
              ),
              MyText(
                isSecure
                    ? '****'
                    : (r'$' +
                        (token.balanceUSDPrice == null
                            ? '--.--'
                            : token.balanceUSDPrice!
                                .toStringAsFixed(2)
                                .formatNumber())),
                style: Theme.of(context).textTheme.listTileSubtitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
