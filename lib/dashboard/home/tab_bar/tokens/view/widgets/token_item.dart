import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TokenItem extends StatelessWidget {
  const TokenItem({
    Key? key,
    required this.token,
  }) : super(key: key);

  final TokenModel token;

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
          leading: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            child: token.iconUrl == null
                ? Container(
                    color: Theme.of(context).primaryColorDark,
                    width: Sizes.tokenLogoSize,
                    height: Sizes.tokenLogoSize,
                  )
                : SizedBox(
                    width: Sizes.tokenLogoSize,
                    height: Sizes.tokenLogoSize,
                    child: CachedImageFromNetwork(
                      token.iconUrl!,
                    ),
                  ),
          ),
          title: MyText(
            token.symbol,
            style: Theme.of(context).textTheme.listTileTitle,
          ),
          subtitle: MyText(
            token.name,
            style: Theme.of(context).textTheme.listTileSubtitle,
          ),
          trailing: MyText(
            token.price,
            style: Theme.of(context)
                .textTheme
                .listTileTitle
                .copyWith(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
