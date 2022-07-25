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
            child: iconUrl() == null
                ? Container(
                    color: Theme.of(context).primaryColorDark,
                    width: Sizes.tokenLogoSize,
                    height: Sizes.tokenLogoSize,
                  )
                : SizedBox(
                    width: Sizes.tokenLogoSize,
                    height: Sizes.tokenLogoSize,
                    child: CachedImageFromNetwork(
                      iconUrl()!,
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
            getPrice(),
            style: Theme.of(context)
                .textTheme
                .listTileTitle
                .copyWith(fontSize: 13),
          ),
        ),
      ),
    );
  }

  String getPrice() {
    final formatter = NumberFormat('#,###');
    final priceString = token.balance;
    final decimals = int.parse(token.decimals);
    if (decimals == 0) {
      final intPart = formatter.format(double.parse(priceString));
      return '$intPart.0';
    } else if (decimals == priceString.length) {
      return '0.$priceString';
    } else if (priceString.length < decimals) {
      final numberOfZero = decimals - priceString.length;
      // ignore: lines_longer_than_80_chars
      return '0.${List.generate(numberOfZero, (index) => '0').join()}$priceString';
    } else {
      final rightPart = formatter.format(
        double.parse(
          priceString.substring(0, priceString.length - decimals),
        ),
      );
      final realDoublePriceInString =
          // ignore: lines_longer_than_80_chars
          '$rightPart.${priceString.substring(priceString.length - decimals, priceString.length)}';
      return realDoublePriceInString;
    }
  }

  String? iconUrl() {
    final iconUrl = token.icon ?? token.thumbnailUri;
    if (iconUrl == null) {
      return null;
    } else {
      return iconUrl.replaceFirst('ipfs://', Urls.talaoIpfsGateway);
    }
  }
}
