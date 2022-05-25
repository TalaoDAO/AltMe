import 'package:altme/home/tokens/models/token_model.dart';
import 'package:altme/home/tokens/view/widgets/token_item.dart';
import 'package:flutter/material.dart';

class TokenList extends StatelessWidget {
  const TokenList({Key? key, required this.tokenList}) : super(key: key);

  final List<TokenModel> tokenList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, index) => TokenItem(
        logoPath: tokenList[index].logoPath,
        name: tokenList[index].name,
        balance: tokenList[index].balance,
        symbol: tokenList[index].symbol,
      ),
      itemCount: tokenList.length,
    );
  }
}
