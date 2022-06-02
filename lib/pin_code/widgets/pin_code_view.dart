import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/pin_code/cubit/pin_code_view_cubit.dart';
import 'package:altme/pin_code/widgets/widgets.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

typedef PasswordEnteredCallback = void Function(String text);
typedef IsValidCallback = void Function();
typedef CancelCallback = void Function();

class PinCodeView extends StatefulWidget {
  const PinCodeView({
    Key? key,
    required this.title,
    this.passwordDigits = 4,
    required this.passwordEnteredCallback,
    required this.cancelButton,
    required this.deleteButton,
    this.shouldTriggerVerification,
    this.isValidCallback,
    CircleUIConfig? circleUIConfig,
    KeyboardUIConfig? keyboardUIConfig,
    this.bottomWidget,
    this.backgroundColor,
    this.cancelCallback,
    this.digits,
  })  : circleUIConfig = circleUIConfig ?? const CircleUIConfig(),
        keyboardUIConfig = keyboardUIConfig ?? const KeyboardUIConfig(),
        super(key: key);

  final String title;
  final int passwordDigits;
  final PasswordEnteredCallback passwordEnteredCallback;

  // Cancel button and delete button will be switched based on the screen state
  final Widget cancelButton;
  final Widget deleteButton;
  final Stream<bool>? shouldTriggerVerification;
  final CircleUIConfig circleUIConfig;
  final KeyboardUIConfig keyboardUIConfig;

  //isValidCallback will be invoked after passcode screen will pop.
  final IsValidCallback? isValidCallback;
  final CancelCallback? cancelCallback;

  final Color? backgroundColor;
  final Widget? bottomWidget;
  final List<String>? digits;

  @override
  State<StatefulWidget> createState() => _PinCodeViewState();
}

class _PinCodeViewState extends State<PinCodeView>
    with SingleTickerProviderStateMixin {
  late StreamSubscription<bool>? streamSubscription;
  late AnimationController controller;
  late Animation<double> animation;
  late final PinCodeViewCubit pinCodeViewCubit = PinCodeViewCubit();

  final log = Logger('altme-wallet/pin_code/enter_pin_code');

  @override
  void initState() {
    super.initState();
    streamSubscription =
        widget.shouldTriggerVerification?.listen(_showValidation);
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    final Animation curve =
        CurvedAnimation(parent: controller, curve: ShakeCurve());
    animation =
        Tween<double>(begin: 0, end: 10).animate(curve as Animation<double>)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              pinCodeViewCubit.setEnteredPasscode('');
              controller.value = 0;
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: pinCodeViewCubit,
      child: BlocBuilder<PinCodeViewCubit, PinCodeViewState>(
        builder: (_, state) {
          return OrientationBuilder(
            builder: (context, orientation) {
              return orientation == Orientation.portrait
                  ? _buildPortraitPasscodeScreen(state.enteredPasscode)
                  : _buildLandscapePasscodeScreen(state.enteredPasscode);
            },
          );
        },
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.title,
      style: Theme.of(context).textTheme.pinCodeTitle,
    );
  }

  Widget _buildPortraitPasscodeScreen(String enteredPasscode) => Stack(
        children: [
          Positioned(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AltMeLogo(size: Sizes.logoLarge),
                  const SizedBox(
                    height: Sizes.spaceLarge,
                  ),
                  _buildTitle(),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: 40,
                    child: AnimatedBuilder(
                      animation: animation,
                      builder: (_, __) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _buildCircles(enteredPasscode),
                        );
                      },
                    ),
                  ),
                  _buildKeyboard(enteredPasscode),
                  widget.bottomWidget ?? Container()
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomRight,
              child: _buildDeleteButton(enteredPasscode),
            ),
          ),
        ],
      );

  Widget _buildLandscapePasscodeScreen(String enteredPasscode) => Stack(
        children: [
          Positioned(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    children: <Widget>[
                      Positioned(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const AltMeLogo(size: Sizes.logoLarge),
                              const SizedBox(
                                height: Sizes.spaceLarge,
                              ),
                              _buildTitle(),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                height: 40,
                                child: AnimatedBuilder(
                                  animation: animation,
                                  builder: (_, __) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: _buildCircles(enteredPasscode),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (widget.bottomWidget != null)
                        Positioned(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: widget.bottomWidget,
                          ),
                        )
                      else
                        Container()
                    ],
                  ),
                  _buildKeyboard(enteredPasscode),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomRight,
              child: _buildDeleteButton(enteredPasscode),
            ),
          )
        ],
      );

  Widget _buildKeyboard(String enteredPass) => NumericKeyboard(
        onKeyboardTap: (text) =>
            _onKeyboardButtonPressed.call(text, enteredPass),
        keyboardUIConfig: widget.keyboardUIConfig,
        digits: widget.digits,
      );

  List<Widget> _buildCircles(String enteredPasscode) {
    final list = <Widget>[];
    final config = widget.circleUIConfig;
    final extraSize = animation.value;
    for (int i = 0; i < widget.passwordDigits; i++) {
      list.add(
        Container(
          margin: const EdgeInsets.all(8),
          child: Circle(
            filled: i < enteredPasscode.length,
            circleUIConfig: config,
            extraSize: extraSize,
          ),
        ),
      );
    }
    return list;
  }

  void _onDeleteCancelButtonPressed(String enteredPasscode) {
    if (enteredPasscode.isNotEmpty) {
      pinCodeViewCubit.setEnteredPasscode(
        enteredPasscode.substring(0, enteredPasscode.length - 1),
      );
    } else {
      if (widget.cancelCallback != null) {
        widget.cancelCallback!.call();
      }
    }
  }

  void _onKeyboardButtonPressed(String text, String enteredPasscode) {
    if (text == NumericKeyboard.deleteButton) {
      _onDeleteCancelButtonPressed(enteredPasscode);
      return;
    }
    if (enteredPasscode.length < widget.passwordDigits) {
      final passCode = enteredPasscode + text;
      pinCodeViewCubit.setEnteredPasscode(passCode);
      if (passCode.length == widget.passwordDigits) {
        widget.passwordEnteredCallback(enteredPasscode);
      }
    }
  }

  @override
  void didUpdateWidget(PinCodeView old) {
    super.didUpdateWidget(old);
    // in case the stream instance changed, subscribe to the new one
    if (widget.shouldTriggerVerification != old.shouldTriggerVerification) {
      streamSubscription?.cancel();
      streamSubscription =
          widget.shouldTriggerVerification?.listen(_showValidation);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    streamSubscription?.cancel();
    pinCodeViewCubit.close();
    super.dispose();
  }

  void _showValidation(bool isValid) {
    if (isValid) {
      _validationCallback();
    } else {
      controller.forward();
    }
  }

  void _validationCallback() {
    if (widget.isValidCallback != null) {
      widget.isValidCallback!();
    } else {
      Navigator.maybePop(context);
      log.warning(
        '''You didn't implement validation callback. Please handle a state by yourself then.''',
      );
    }
  }

  Widget _buildDeleteButton(String passCode) {
    return CupertinoButton(
      onPressed: () => _onDeleteCancelButtonPressed.call(passCode),
      child: Container(
        margin: widget.keyboardUIConfig.digitInnerMargin,
        child: passCode.isEmpty ? widget.cancelButton : widget.deleteButton,
      ),
    );
  }
}
