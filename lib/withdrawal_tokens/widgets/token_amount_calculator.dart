import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/withdrawal_tokens/withdrawal_tokens.dart';
import 'package:flutter/material.dart';

class TokenAmountCalculatorView extends StatelessWidget {
  const TokenAmountCalculatorView({
    Key? key,
    required this.tokenSymbol,
    required this.tokenModel,
  }) : super(key: key);

  final String tokenSymbol;
  final TokenModel tokenModel;

  @override
  Widget build(BuildContext context) {
    return _TokenAmountCalculator(
      tokenSymbol: tokenSymbol,
      tokenModel: tokenModel,
    );
  }
}

class _TokenAmountCalculator extends StatefulWidget {
  const _TokenAmountCalculator({
    Key? key,
    required this.tokenSymbol,
    required this.tokenModel,
  }) : super(key: key);
  final String tokenSymbol;
  final TokenModel tokenModel;

  @override
  State<_TokenAmountCalculator> createState() => _TokenAmountCalculatorState();
}

class _TokenAmountCalculatorState extends State<_TokenAmountCalculator> {
  final amountController = TextEditingController();

  void _insertKey(String key) {
    if (key.length > 1) return;
    final text = amountController.text;
    amountController.text = text + key;
    amountController.selection = TextSelection.fromPosition(
      TextPosition(offset: amountController.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: Sizes.spaceNormal,
          ),
          TextField(
            controller: amountController,
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
            maxLines: 1,
            cursorWidth: 4,
            cursorRadius: const Radius.circular(4),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              //isDense: true,
              border: InputBorder.none,
              hintText: '0',
              contentPadding: EdgeInsets.zero,
              suffixIcon: Text(
                widget.tokenSymbol,
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
          ),
          const UsdValueText(),
          MaxButton(
            onTap: () {
              amountController.text = widget.tokenModel.calculatedBalance;
              amountController.selection = TextSelection.fromPosition(
                TextPosition(offset: amountController.text.length),
              );
            },
          ),
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
                      onTap: _insertKey,
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
                      onLongPress: (_) {
                        amountController.text = '';
                      },
                      onTap: (_) {
                        final text = amountController.text;
                        if (text.isNotEmpty) {
                          amountController.text =
                              text.substring(0, text.length - 1);
                          amountController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                              offset: amountController.text.length,
                            ),
                          );
                        }
                      },
                    ),
                    onKeyboardTap: _insertKey,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
