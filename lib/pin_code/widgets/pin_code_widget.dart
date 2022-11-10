import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PinCodeWidget extends StatefulWidget {
  const PinCodeWidget({
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
    this.subTitle,
    this.header,
  })  : circleUIConfig = circleUIConfig ?? const CircleUIConfig(),
        keyboardUIConfig = keyboardUIConfig ?? const KeyboardUIConfig(),
        super(key: key);

  final Widget? header;
  final String title;
  final String? subTitle;
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

  @override
  State<StatefulWidget> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends State<PinCodeWidget>
    with SingleTickerProviderStateMixin {
  late StreamSubscription<bool>? streamSubscription;
  late AnimationController controller;
  late Animation<double> animation;

  final log = getLogger('PinCodeWidget');

  @override
  void initState() {
    super.initState();
    streamSubscription =
        widget.shouldTriggerVerification?.listen(_showValidation);
    controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    final Animation curve =
        CurvedAnimation(parent: controller, curve: ShakeCurve());
    animation =
        Tween<double>(begin: 0, end: 10).animate(curve as Animation<double>)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              context.read<PinCodeViewCubit>().setEnteredPasscode('');
              controller.value = 0;
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PinCodeViewCubit, PinCodeViewState>(
      builder: (context, state) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return orientation == Orientation.portrait
                ? Stack(
                    children: [
                      Positioned(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (widget.header != null)
                              widget.header!
                            else
                              const AltMeLogo(size: Sizes.logoLarge),
                            const SizedBox(height: Sizes.spaceNormal),
                            PinCodeTitle(
                              title: widget.title,
                              subTitle: widget.subTitle,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              height: 40,
                              child: AnimatedBuilder(
                                animation: animation,
                                builder: (_, __) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: _buildCircles(),
                                  );
                                },
                              ),
                            ),
                            NumKeyboard(
                              passwordEnteredCallback:
                                  widget.passwordEnteredCallback,
                              keyboardUIConfig: widget.keyboardUIConfig,
                              passwordDigits: widget.passwordDigits,
                              cancelCallback: widget.cancelCallback,
                            ),
                            widget.bottomWidget ?? Container()
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: DeleteButton(
                            cancelButton: widget.cancelButton,
                            deleteButton: widget.deleteButton,
                            cancelCallback: widget.cancelCallback,
                            keyboardUIConfig: widget.keyboardUIConfig,
                          ),
                        ),
                      ),
                    ],
                  )
                : Stack(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (widget.header != null)
                                            widget.header!
                                          else
                                            const AltMeLogo(
                                              size: Sizes.logoLarge,
                                            ),
                                          const SizedBox(
                                            height: Sizes.spaceNormal,
                                          ),
                                          PinCodeTitle(
                                            title: widget.title,
                                            subTitle: widget.subTitle,
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            height: 40,
                                            child: AnimatedBuilder(
                                              animation: animation,
                                              builder: (_, __) {
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: _buildCircles(),
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
                              NumKeyboard(
                                passwordEnteredCallback:
                                    widget.passwordEnteredCallback,
                                keyboardUIConfig: widget.keyboardUIConfig,
                                passwordDigits: widget.passwordDigits,
                                cancelCallback: widget.cancelCallback,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: DeleteButton(
                            cancelButton: widget.cancelButton,
                            deleteButton: widget.deleteButton,
                            cancelCallback: widget.cancelCallback,
                            keyboardUIConfig: widget.keyboardUIConfig,
                          ),
                        ),
                      )
                    ],
                  );
          },
        );
      },
    );
  }

  List<Widget> _buildCircles() {
    final PinCodeViewCubit pinCodeViewCubit = context.read<PinCodeViewCubit>();
    final enteredPasscode = pinCodeViewCubit.state.enteredPasscode;
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

  @override
  void didUpdateWidget(PinCodeWidget old) {
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
      widget.isValidCallback!.call();
    } else {
      Navigator.maybePop(context);
      log.w(
        '''You didn't implement validation callback. Please handle a state by yourself then.''',
      );
    }
  }
}
