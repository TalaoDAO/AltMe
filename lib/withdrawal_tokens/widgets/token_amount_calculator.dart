import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class TokenAmountCalculatorView extends StatelessWidget {
  const TokenAmountCalculatorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _TokenAmountCalculator();
  }
}

class _TokenAmountCalculator extends StatefulWidget {
  const _TokenAmountCalculator({Key? key}) : super(key: key);

  @override
  State<_TokenAmountCalculator> createState() => _TokenAmountCalculatorState();
}

class _TokenAmountCalculatorState extends State<_TokenAmountCalculator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sizes.spaceNormal),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          NumericKeyboard(
              keyboardUIConfig: KeyboardUIConfig(digitShape: BoxShape.rectangle,digitBorderWidth: 0.0), onKeyboardTap: (key) {})
        ],
      ),
    );
  }
}
