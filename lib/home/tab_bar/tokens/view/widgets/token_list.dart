import 'package:altme/home/tab_bar/tokens/models/models.dart';
import 'package:altme/home/tab_bar/tokens/view/widgets/widgets.dart';
import 'package:flutter/material.dart';

class TokenList extends StatelessWidget {
  const TokenList({Key? key, required this.tokenList, required this.onRefresh})
      : super(key: key);

  final List<TokenModel> tokenList;
  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (_, index) => TokenItem(
          logoPath: tokenList[index].logoPath,
          name: tokenList[index].name,
          balance: tokenList[index].balance,
          symbol: tokenList[index].symbol,
        ),
        itemCount: tokenList.length,
      ),
    );
  }
}
