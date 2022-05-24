import 'package:flutter/material.dart';

class TokenItem extends StatelessWidget {
  const TokenItem({
    Key? key,
    required this.logoUrl,
    required this.symbol,
    required this.balance,
  }) : super(key: key);

  final String logoUrl;
  final String symbol;
  final String balance;

  @override
  Widget build(BuildContext context) {
    // TODO(Taleb): update widget
    return Container();
  }
}
