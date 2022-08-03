import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            TextField(),
            Text('data'),
            Expanded(
              child: SizedBox(
                child: LayoutBuilder(
                  builder: (_, constraint) {
                    return NumericKeyboard(
                      keyboardUIConfig: KeyboardUIConfig(
                        digitShape: BoxShape.rectangle,
                        spacing: 40,
                        digitInnerMargin: EdgeInsets.zero,
                        keyboardRowMargin: EdgeInsets.zero,
                        digitBorderWidth: 0,
                        digitTextStyle: Theme.of(context)
                            .textTheme
                            .calculatorKeyboardDigitTextStyle,
                        keyboardSize: constraint.biggest,
                      ),
                      leadingButton: KeyboardButton(
                        digitShape: BoxShape.rectangle,
                        digitBorderWidth: 0,
                        label: '.',
                        semanticsLabel: '.',
                        onTap: (semanticLabel) {
                        },
                      ),
                      trailingButton: KeyboardButton(
                        digitShape: BoxShape.rectangle,
                        digitBorderWidth: 0,
                        semanticsLabel: 'delete',
                        icon: Image.asset(
                          IconStrings.keyboardDelete,
                          width: Sizes.icon2x,
                          color: Colors.white,
                        ),
                        onTap: (semanticLabel) {
                        },
                      ),
                      onKeyboardTap: (key) {
                        print('key: $key');
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
