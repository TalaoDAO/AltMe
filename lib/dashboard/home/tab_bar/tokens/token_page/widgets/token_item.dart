import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          minVerticalPadding: 0,
          leading: token.iconUrl == null
              ? const CircleAvatar(
                  backgroundColor: Colors.transparent,
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
            token.name.isEmpty ? token.symbol : token.name,
            style: Theme.of(context).textTheme.titleMedium,
            maxLength: 10,
          ),
          subtitle: MyText(
            token.symbol,
            style: Theme.of(context).textTheme.bodyMedium,
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
                      : ('''${token.calculatedBalanceInDouble.decimalNumber(token.decimalsToShow).formatNumber} ${token.symbol}'''),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 13),
                ),
              ),
              Flexible(
                child: MyText(
                  isSecure
                      ? '****'
                      : (r'$' +
                          token.balanceInUSD.decimalNumber(2).formatNumber),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
