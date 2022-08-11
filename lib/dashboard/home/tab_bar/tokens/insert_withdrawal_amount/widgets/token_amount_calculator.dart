import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef OnAmountChanged = Function(double);

class TokenAmountCalculatorView extends StatelessWidget {
  const TokenAmountCalculatorView({
    Key? key,
    required this.tokenAmountCalculatorCubit,
  }) : super(key: key);

  final TokenAmountCalculatorCubit tokenAmountCalculatorCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TokenAmountCalculatorCubit>(
      create: (_) => tokenAmountCalculatorCubit,
      child: const _TokenAmountCalculator(),
    );
  }
}

class _TokenAmountCalculator extends StatefulWidget {
  const _TokenAmountCalculator({
    Key? key,
  }) : super(key: key);

  @override
  State<_TokenAmountCalculator> createState() => _TokenAmountCalculatorState();
}

class _TokenAmountCalculatorState extends State<_TokenAmountCalculator> {
  final amountController = TextEditingController();

  late final _selectionControls = Platform.isIOS
      ? AppCupertinoTextSelectionControls(onPaste: _onPaste)
      : AppMaterialTextSelectionControls(onPaste: _onPaste);

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onPaste(TextSelectionDelegate value) async {
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text ?? '';
    if (text.isEmpty) {
      return;
    } else {
      context.read<TokenAmountCalculatorCubit>().setAmount(amount: text);
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void _insertKey(String key) {
    if (key.length > 1) return;
    if (key == '.' && amountController.text.contains('.')) return;
    final text = amountController.text;
    context.read<TokenAmountCalculatorCubit>().setAmount(amount: text + key);
  }

  void _setAmountControllerText(String text) {
    amountController.text = text.formatNumber();
    amountController.selection = TextSelection.fromPosition(
      TextPosition(offset: amountController.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: Sizes.spaceLarge,
          ),
          BlocBuilder<TokenAmountCalculatorCubit, TokenAmountCalculatorState>(
            builder: (context, state) {
              _setAmountControllerText(state.amount);
              return Column(
                children: [
                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      selectionControls: _selectionControls,
                      controller: amountController,
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      cursorWidth: 4,
                      autofocus: false,
                      validator: (value) {
                        final isValid = context
                            .read<TokenAmountCalculatorCubit>()
                            .isValidateAmount(amount: value);
                        if (isValid) {
                          return null;
                        } else {
                          return l10n.insufficientBalance;
                        }
                      },
                      keyboardType: TextInputType.none,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      cursorRadius: const Radius.circular(4),
                      onChanged: (value) {
                        if (value != amountController.text) {
                          context
                              .read<TokenAmountCalculatorCubit>()
                              .setAmount(amount: value);
                        }
                      },
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(Sizes.smallRadius),
                          ),
                        ),
                        hintText: '0',
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        suffixText: state.selectedToken.symbol,
                        suffixStyle:
                            Theme.of(context).textTheme.headline6?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                      ),
                    ),
                  ),
                  const UsdValueText(),
                  MaxButton(
                    onTap: () {
                      _setAmountControllerText(
                        state.selectedToken.calculatedBalance,
                      );
                      context
                          .read<TokenAmountCalculatorCubit>()
                          .setAmount(amount: amountController.text);
                    },
                  ),
                ],
              );
            },
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.7,
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
                            context
                                .read<TokenAmountCalculatorCubit>()
                                .setAmount(amount: '');
                          },
                          onTap: (_) {
                            final text = amountController.text;
                            if (text.isNotEmpty) {
                              String amount = '';
                              if (text.length > 1) {
                                amount = text.substring(0, text.length - 1);
                              }
                              context
                                  .read<TokenAmountCalculatorCubit>()
                                  .setAmount(
                                    amount: amount,
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
            ),
          ),
        ],
      ),
    );
  }
}
