import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class TokenSelectBox extends StatefulWidget {
  const TokenSelectBox({Key? key}) : super(key: key);

  @override
  State<TokenSelectBox> createState() => _TokenSelectBoxState();
}

class _TokenSelectBoxState extends State<TokenSelectBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sizes.spaceSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(Sizes.normalRadius),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [],
      ),
    );
  }
}
