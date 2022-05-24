import 'package:altme/app/app.dart';
import 'package:altme/home/tokens/models/token_model.dart';
import 'package:altme/home/tokens/view/widgets/token_item.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class TokenList extends StatelessWidget {
  const TokenList({Key? key, required this.tokenList}) : super(key: key);

  final List<TokenModel> tokenList;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${tokenList.length} ${l10n.items}'),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: Sizes.nftItemRatio,
            ),
            itemBuilder: (_, index) => TokenItem(
              logoUrl: tokenList[index]
                  .logoUri
                  .replaceAll('ipfs://', 'https://ipfs.io/ipfs/'),
              balance: '${tokenList[index].balance} XTZ',
              // TODO(Taleb): update
              symbol: tokenList[index].symbol,
            ),
            itemCount: tokenList.length,
          ),
        ),
      ],
    );
  }
}
