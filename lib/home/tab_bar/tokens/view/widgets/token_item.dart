import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
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
    final numberFormatter = NumberFormat('#,###,000');
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
            child: iconUrl() == null
                ? Container(
                    color: Theme.of(context).primaryColorDark,
                    width: Sizes.tokenLogoSize,
                    height: Sizes.tokenLogoSize,
                  )
                : Image.network(
                    iconUrl()!,
                    width: Sizes.tokenLogoSize,
                    height: Sizes.tokenLogoSize,
                  ),
          ),
          title: MyText(
            token.name.toUpperCase(),
            style: Theme.of(context).textTheme.listTileTitle,
          ),
          subtitle: MyText(
            token.symbol,
            style: Theme.of(context).textTheme.listTileSubtitle,
          ),
          trailing: MyText(
            token.balance == '0'
                ? token.balance
                : numberFormatter.format(double.parse(token.balance)),
            style: Theme.of(context)
                .textTheme
                .listTileTitle
                .copyWith(fontSize: 13),
          ),
        ),
      ),
    );
  }

  String? iconUrl() {
    final iconUrl = token.icon ?? token.thumbnailUri;
    if (iconUrl == null) {
      return null;
    } else {
      return iconUrl.replaceFirst('ipfs://', 'https://ipfs.io/ipfs/');
    }
  }
}
